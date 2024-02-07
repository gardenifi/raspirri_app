import 'package:mqtt_client/mqtt_client.dart';

Stream<List<MqttReceivedMessage<MqttMessage>>> createStream(
    {required String topic, required String text}) {
  MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(text);
  MqttPublishPayload payload = MqttPublishPayload();
  payload.message = builder.payload!;

  MqttPublishMessage message = MqttPublishMessage();
  message.payload = payload;

  MqttReceivedMessage<MqttMessage> mes = MqttReceivedMessage(topic, message);
  List<MqttReceivedMessage<MqttMessage>> data = [mes];

  return Stream.fromIterable([data]);
}
