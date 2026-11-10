package no.pgr301.exam.service;

import no.pgr301.exam.model.AnalyzeResponse;
import no.pgr301.exam.model.GiftAnalysis;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.DistributionSummary;
import io.micrometer.core.instrument.MeterRegistry;

@Service
public class WishlistService {

    private final S3Service s3;
    private final RekognitionService rekognition;
    private final BedrockService bedrock;

    private final Counter imagesAnalyzed;
    private final Counter giftsGenerated;
    private final DistributionSummary giftsPerRequest;

    public WishlistService(S3Service s3,
            RekognitionService rekognition,
            BedrockService bedrock,
            MeterRegistry meterRegistry) {
        this.s3 = s3;
        this.rekognition = rekognition;
        this.bedrock = bedrock;

        this.imagesAnalyzed = Counter.builder("wishifai.images.analyzed")
                .description("Amount of pictures analyzed")
                .register(meterRegistry);

        this.giftsGenerated = Counter.builder("wishifai.gifts.generated")
                .description("Amount of gift suggestions generated")
                .register(meterRegistry);

        this.giftsPerRequest = DistributionSummary.builder("wishifai.gifts.per.request")
                .description("Amount of gift suggestions per request")
                .register(meterRegistry);
    }

    public AnalyzeResponse process(byte[] bytes, String filename, String contentType) {
    String s3Key = s3.upload(bytes, filename, contentType);

    List<String> labels = rekognition.detectLabels(bytes);
    imagesAnalyzed.increment();

    GiftAnalysis analysis = bedrock.suggestGifts(labels);

    int suggestionCount = analysis.suggestions().size();
    giftsGenerated.increment(suggestionCount);
    giftsPerRequest.record(suggestionCount);

    return new AnalyzeResponse(
            s3Key,
            labels,
            analysis.roomAnalysis(),
            analysis.recipientProfile(),
            analysis.suggestions(),
            Instant.now().toString()
    );
}
}
