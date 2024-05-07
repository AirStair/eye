import tensorflow as tf
import tensorflow_hub as hub
import boto3
import os

session = boto3.session.Session()
s3 = session.client(
    aws_access_key_id=os.environ[''],
    aws_secret_access_key=os.environ[''],
    endpoint_url=os.environ['']
)
model = hub.load("https://tfhub.dev/captain-pool/esrgan-tf2/1")
concrete_func = model.signatures[tf.saved_model.DEFAULT_SERVING_SIGNATURE_DEF_KEY]

@tf.function(input_signature=[tf.TensorSpec(shape=[1, 50, 50, 3], dtype=tf.float32)])
def f(input):
  return concrete_func(input)

converter = tf.lite.TFLiteConverter.from_concrete_functions([f.get_concrete_function()], model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

with tf.io.gfile.GFile("ESRGAN.tflite", "wb") as f:
  f.write(tflite_model)\

esrgan_model_path = "./ESRGAN.tflite"

test_img_path = "./1714923195584.jpg"

lr = tf.io.read_file(test_img_path)
lr = tf.image.decode_jpeg(lr)
lr = tf.expand_dims(lr, axis=0)
lr = tf.cast(lr, tf.float32)

interpreter = tf.lite.Interpreter(model_path=esrgan_model_path)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

interpreter.set_tensor(input_details[0]["index"], lr)
interpreter.invoke()

output_data = interpreter.get_tensor(output_details[0]["index"])
sr = tf.squeeze(output_data, axis=0)
sr = tf.clip_by_value(sr, 0, 255)
sr = tf.round(sr)
sr = tf.cast(sr, tf.uint8)
