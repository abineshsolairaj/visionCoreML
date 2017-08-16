# visionCoreML
# Welcome to Vision and CoreML Exploration. 

   Hi, all. Welcome to Vision and CoreML Exploration. It's been a month since Apple released its Vision, CoreML and AR frameworks which were considered as the most eye catching updates of WWDC17. I got some time to play around with these frameworks and created an app. Please check out the project below.
   
   This app shows a demo of all the Vision Framework features along with the CoreML introduced in WWDC17. The Following are the features you will go through in the app.
1) Rectangles Detection
2) Face Detection
3) Object Tracking
4) Text Detection
5) Object Recognition
6) Number Recognition
7) Text Recognition
8) Face Recognition
The first four features use vision framework and the rest use vision along with CoreML. This blog will give you the overview of how the whole vision and coreml works.

Vision and Core Machine Learning Framework:
           Apple's vision framework helps us to perform high-performance image analysis on image and video. CoreML framework predicts those images using trained or learning models.

Neural Network:
           Neural networks are a programming paradigm which enables your computer to learn from data and deep learning provides techniques for learning.
Wondering why neural networks come into the picture?
CoreML models are completely built on neural networks. In simple words, the output is given to the hidden layers(computation layers) along with the data set to provide the desired output along with the feedback from each of the hidden layers. The number of hidden layers is directly proportional to the accuracy. The sample models provided by Apple have 2,3 layer and are trained models which don't learn anymore(i.e) they compute always with the same data set and never depend on feedback. But ideally, a deep learning(Feed Forward Neural Network) would be the best for learning.
It's always fun to make a machine learn.

Model Creation:
         The CoreML models used in this app are sample models provided by Apple.
Does this mean that you have to depend on Apple for models?
Absolutely No. You can create your own models. There are some basic frameworks supported by Apple. These frameworks implement the neural network concepts to input the image and along with the data set produce the desired results. The data set and the computation decides the efficiency of the model.
1) Keras
2) Caffe
3) Scikitlearn and so on...
All these frameworks are built over TensorFlow(an deep learning framework) which serves as the foundation. These models are written primarily in Python(.py) and converted to coreml models(.coreml) using coreml tools. I will post a separate blog on how to create your own model and convert it to coreml model to be used in your app.

Image Capture:
           For capturing and processing images, there are two ways to capture an image - Core Image and AV Capture. But in WWDC17, Apple released the Vision framework which is more powerful at the cost of processing power and time.

App Structure:
        Each of the features in the app follows the same structure. The image buffer(CVPixelBuffer) is captured and sent as input to Vision Request and then handled using Vision Handler and finally, the observations are computed and displayed as results. I will leave the technicalities for you to explore from the project.

Finally, I personally felt CoreML is gonna be the game changing platform for many enterprises and consumer markets. There's no doubt that many of us would get the motivation to pursue machine learning and data science as passion. Feel free to let me know, if any further information or clarifications are required. Happy Learning.

                         "Humans learn, since birth, why not we give that ability to machines."
