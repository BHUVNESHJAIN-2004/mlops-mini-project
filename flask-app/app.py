from flask import Flask,render_template,request
import mlflow
from preprocessing_utility import normalize_text
import dagshub
import pickle

app = Flask(__name__)
mlflow.set_tracking_uri("https://dagshub.com/bhuvneshjain2004/mlops-mini-project.mlflow")
dagshub.init(repo_owner='bhuvneshjain2004', repo_name='mlops-mini-project', mlflow=True)

# fetch  the latest model verion dynamically
# def fetch_latest_model_version(model_name):
#     client = mlflow.tracking.MlflowClient()
#     latest_version = client.get_latest_versions(model_name,stages=['Production']) 
#     if not latest_version:
#         latest_version = client.get_latest_versions(model_name,stages=['None']) 
#     return latest_version[0].version if latest_version else None   


# load model from model registry
model_name = "my_model"
# model_version = fetch_latest_model_version(model_name)
model_version = 3
model_uri = f"models:/{model_name}/{model_version}"
model = mlflow.pyfunc.load_model(model_uri)

vectorizer = pickle.load(open('models/vectorizer.pkl','rb'))

@app.route('/')
def home():
    return render_template('index.html',result=None)

@app.route('/predict',methods=['post'])
def predict():
    text = request.form['text']

    # clean the text
    text = normalize_text(text)

    # bow
    features = vectorizer.transform([text])

    # prediction
    result = model.predict(features)
    return render_template('index.html',result=result[0])


if __name__ == '__main__':
    app.run(debug=True, use_reloader=True)