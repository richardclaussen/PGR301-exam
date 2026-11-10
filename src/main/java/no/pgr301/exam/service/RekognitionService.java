package no.pgr301.exam.service;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.services.rekognition.RekognitionClient;
import software.amazon.awssdk.services.rekognition.model.DetectLabelsRequest;
import software.amazon.awssdk.services.rekognition.model.DetectLabelsResponse;
import software.amazon.awssdk.services.rekognition.model.Image;
import software.amazon.awssdk.services.rekognition.model.Label;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;

import java.util.List;

@Service
public class RekognitionService {

    private final RekognitionClient client;
    private final Timer rekognitionTimer;

    public RekognitionService(RekognitionClient client, MeterRegistry meterRegistry) {
        this.client = client;
        this.rekognitionTimer = Timer.builder("wishifai.rekognition.duration")
                .description("Time Rekognition uses to analyse a picture")
                .register(meterRegistry);
    }

    public List<String> detectLabels(byte[] bytes) {
        Timer.Sample sample = Timer.start();

        try {
            DetectLabelsResponse resp = client.detectLabels(DetectLabelsRequest.builder()
                    .image(Image.builder()
                            .bytes(SdkBytes.fromByteArray(bytes))
                            .build())
                    .maxLabels(20)
                    .minConfidence(70f)
                    .build());

            return resp.labels().stream()
                    .map(Label::name)
                    .toList();
        } finally {
            sample.stop(rekognitionTimer);
        }
    }
}
