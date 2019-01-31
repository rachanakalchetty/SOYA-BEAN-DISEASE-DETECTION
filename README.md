SOYA BEAN DISEASE DETECTION
Developed a system to detect diseases caused by soya bean using image processing and neural networks(CNN).The KNN algorithm is used to extract the affected part of the leaf . SVM and NN is used to classify the disease. Based on disease predicted pesticide and dosage suggestion are made.
Agriculture is the backbone of the Indian economy. Though there have been advance- ments in technology and agricultural practices through time, some parts of India are still deprived from majority of them. As a result, the final reap of the efforts put in by the farmers is a lot less than what it must be. And, Soybean is one of the most important export crops in India. In this project, we have proposed an algorithm that uses techniques of image processing, machine learning and soft computing to detect diseases in Soybean leaf and also makes pesticide and dosage suggestions. The main focus of the project is on classification of Soybean leaf diseases- Frogeye, Powdery mildew, Rust, Downy mildew and Cercospora blight. In the proposed algorithm, mage processing techniques are used to enhance quality of the input images. Then KNN algorithm is used to extract the infected portion of the leaf from the image. Other various algorithms like Neural networks, Support Vector Machines are used to classify the diseases mentioned. Accuracy of 90% is obtained. Then based on the classification, pesticide and dosage suggestions are made.
1 Introduction
1.1 Characteristics of diseases
1. Frogeye: When the Soybean leaf is affected by frogeye, it will start getting lesions which begin as small, dark, water-soaked spots. Which later, develop into brown spots surrounded by a darker reddish-brown or purple rings. The center of the lesions turn light brown or light gray as they grow.
2. Powdery Mildew: Affected leaves have white to light gray, powdery patches. These patches may grow large and cover the surfaces of many leaves throughout a plant.
3. Rust: It exhibits tan or reddish-brown lesions (spots) that develop first on the underside of leaves. Small pustules (blisters) develop in the lesions, which break open and release masses of tan spores.
4. Downy Mildew: The Downy Mildew affected leaf will have small, light green spots (not water-soaked) on upper leaf surfaces which are just the initial symptoms of downy mildew . The spots then grow large and turn pale to bright yellow.
5. Cercospora Blight: The discolored areas on the infected leaf expand and deepen in color to a reddish-purple or bronze. The infected leaves appear leathery and ‘sunburned’. Red-brown spots may develop on both leaf surfaces.
8
1.2 Introduction to problem domain
The solution to the problem at hand is concerned with the following domains - 1. Digital Image Processing : Image processing consists of three steps:
– Image acquisition tools are used to import images.
– Analyzing and manipulating the image.
– Output may consist of an image that is the altered version of the input image or may be a report summarizing the analysis of the image.
Image processing can be widely classified into:
– Analogue image processing : It is mainly used on hard copies like print outs and photographs. The use of these visual techniques require knowledge of various fundamentals of interpretation.
– Digital image processing : This involves manipulation of digital images done using computers. It is a subcategory of digital signal processing. It mainly consists of three phases:- pre-processing, enhancement & display, information extraction.
Pre-processing aims at providing clean data in a necessary format which is ob- tained by filtering unwanted data, noise and then applying the techniques that render data in the required format.
Enhancement is the phase where the spotlight is on the quality of data. The quality of data is enhanced using various methods in order to overcome the dis- crepancies and bugs that may occur due to the diversity of source and diversity of other factors related to the data.
Information extraction phase is the final phase where the required knowledge or information is elicited from the output of the previous two phases. The techniques used in and the output of this phase is highly dependent on the application for which the information will be used.

Proposed solution methods

Algorithm for detection and classification of disease using Soybean leaf images is pro- posed. Images taken as input are downloaded from internet and a homemade dataset is prepared. Images are captured from digital camera and stored in standard jpeg format with a minimum resolution of 256 * 256 pixels for Soybean diseases identification. Dis- ease detection includes various steps like image enhancement, segmentation. Flowchart of proposed system is given in Figure 2. The proposed solution is designed to pre- dict only 5 diseases i.e Frogeye, Downy Mildew, Powdery Mildew, Rust & Cercospora Blight. The Classification algorithms used are Convolutional Neural Network(CNN), Multi SVM; We have implemented these two algorithms in order to make a compara- tive study intended to determine which of them may be more suitable for our problem at hand.
