## Markov-Modeling
  -  This code builds spatio-temporal Markov Chain transition matrices for states/regions in the US using the Maximum Likelihood Estimation Method
  
  -  The transition matrices built are for predicting the spread of protests across all US states, which have been aggregated into grid 
    cells based on longitudes and latitudes. The transition matrix for each cell tells the probability with which the cell transitions 
    from one Markov state (here, state is used to mean the presence/absence of protests) to another -- see presentation for more details
    
  -  The close to 100% generality of the code allows it to work on any dataset to produce transition matrices that can be used to make predictions 
    on the provided dataset. See description below (under @ code) for how this can be done


## The project contains the following folders and files:
### @ code folder
#### Dataset: US_BLM_Protests.xlsx  
-	**Place dataset in same folder as MATLAB code to run code on**
- We chose this dataset because it is an instance that fits the description and conditions of our model
- You may thus swap the current dataset with whatever dataset you wish to model as long as it fits the 
  decription of the parameters discussed in the markov-modeling-presentation.pptx file (see @ published-code)
- Note that a couple of tweaks, specifically variable name changing, may need to be made to the model_informing.m 
  file to make the code work on the data you provide if you decide to use this code on your own dataset
- This can be easily done by just replacing the variable names in model_informing.m for the headings in the 
  US_BLM_Protests.xlsx file with the corresponding headings in the new excel file you provide
- However, if you find this too technical to do, but still want to use the computational power of final_code.m,
  which is the powerhouse of this repo, then go ahead and generate your own set of matrix data and feed it to 
  final_code.m (See comments in final_code.m for how this can be done)

#### Matlab code: model_informing.m
-	This code imports the excel dataset, processes it into a set of matrix data, creates usable variables that points 
  to the set of matrix data (which final_code.m can use), and overlays the dataset on the US map for a pictorial 
  view of the data that final_code.m will work with 
-	**Run this code before final_code.m**
- See published-folder for a published pdf version of this file

#### Matlab code: final_code.m
-	This is the main code that creates the transition matrices and plots their heat maps
- Outputs generated when the code is run on US_BLM_Protests.xlsx has been saved as .jpg 
  files and put in the transition-matrices-map folder, which in turn is in the code-ouputs folder
-	See published-folder for a published pdf version of final_code.m
      
### @ published-code folder
- model_informing.m: Published pdf version of model_informing.m
-	final_code.pdf: Published pdf version of final_code.m

### @ code-outputs folder
- Contans results output from running the code on US_BLM_Protests.xlsx

### @ presentation folder
- Explains the setup, approach, and results for the entire experiment, including the logic behind the model used in the code


## Authors: 
- Edmund Aduse Poku 
- Charlie Reeder 
- Chris Kartsonis
- Chikezie Prosper Onungwa
- Jasper White
  
