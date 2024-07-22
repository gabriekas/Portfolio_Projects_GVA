# Exploratory Data Analysis of Coursera Course Dataset with Python

## Project Description
Current project focuses on data exploration of Coursera Course Dataset using Python. The project aims to uncover insights that would help to understand the dataset, identify patterns that may influence course popularity and complement further analysis. 

## Disclaimer
 _The project was performed for learning purposes. Additionally, the dataset was scraped on May 2020, hence, provided insights should not be taken as current of professional advice._

## Dataset Information
- **Source**: https://www.kaggle.com/datasets/siddharthm1698/coursera-course-dataset/data
- **Description**:  
The dataset contains the following information:  
    - Course title
    - Organization which provides the course
    - Certificate type of the course
    - Course rating
    - Course Difficulty
    - Number of students enrolled onto the course
- **Number of Observations After Data Pre-Processing**: 891.
- **Number of Features  After Data Pre-Processing**: 10.

## Prerequisites
To run current analysis, the following is required:
- Python
- Jupyter Notebook
- Libraries: pandas, plotly.express, plotly.offline

## Contents
1. Download the Coursera Course Dataset from Kaggle  
2. Initialisation
3. Data Cleaning
    3.1. Handle Missing Data
    3.2. Handle Duplicate Data
    3.3. Treating the Outliers
    3.4. Data Categorization and Categorical Encoding
4. Exploratory Data Analysis
    4.1. Initial observations of the Dataset
    4.2. Which features are categorical and which are numerical?
    4.3. Which courses are the most popular (by student enrollment)?
    4.4. Which courses are the most popular (by course rating)?
    4.5. How does student enrollment compare to top courses by enrollment and top courses by rating?
    4.6. What are the ratings and difficulty levels of courses with highest enrollment?
    4.7. Which courses are the least popular (by student enrollment)?
    4.8. Which courses are the least popular (by course rating)?
    4.9. How does student enrollment compare to least popular courses by enrollment and least popular courses by rating?
    4.10. How does rating affect enrollment? Is there a correlation?
    4.11. Which organizations offer the most popular courses(by student enrollment)?  
    How many courses these organizations provide in total?  
    How the numbers compare to mean and median?
    4.12. Which certification types are most common?
    4.13. Which organizations provide professional certificates?
    4.14. How certitifation types compare across top organizations by student enrollment?
    4.15. Which organizations offer the highest-rated courses?
    4.16. How does average rating compare between top organizations by student enrollment and top organizations by rating?
    4.17. Do higher difficulty courses have fewer enrollments compared to easier courses?
    4.18. How do student enrollment vary across different certification types?
    4.19. Which certification type tends to be associated with higher-rated courses?
    4.20. Is there a correlation between the difficulty level of a course and its rating?
    4.21. How does average rating compare to course difficulty?
    4.22. Are there any organizations that specialize in a particular difficulty level of courses?
5. Key Takeaways
6. Actionable Insights
7. Further Improvement

## Key Takeways of the Analysis
- "Machine Learning" course had the highest number of students enrolled (3.2M) whilst "El Abogado del Futuro: Legaltech y la Transformacion Digital del Derecho" had the least number of students enrolled (1.5k). Number of students enrolled to both courses are way above and below the mean (90,522), respectively.
- 6 out of 10 top rated courses have very low student enrollment below the mean.  
- Most coursera courses are rated fairly good with mean being 4.68. The lowest observed rating was 3.3.   
- Top 10 courses by student enrollment have excellent ratings, only those whose difficulty level is _beginner_ have slightly lower ratings, particularly "Career Success".   
- There was no clear trend observed how course rating affects course enrollment. However, a tendency of courses with higher rating having more students enrolled was seen.  
- Majority of courses provide "Course Certificate" (65.32%) whilst "Specialization Certificate" and "Professional Certificate" are provided only by 33.33% and 1.35% courses, respectively.  
- Whilst mean and median of courses provided by each organization is 6 and 3, respectively, number of courses provided by top organizations by student enrollment ranges between 16 and 59 courses. Namely, "University of Pennsylvania provides 59 courses.
- "University of California, Irvine" is the only organization in top organizations by student enrollment that provides more courses with specialization certificates than course certificate and 1 professional certificate. In comparison, other top organizations provide courses with course certificates mostly.  
- No meaningful relationship between course difficulty and course rating was observed.  
- Although most top organizations specialise into beginner and intermediate difficulty courses, "Autodesk" is the only one that provides 50% advanced and 50% intermediate courses, and "Arizona State University" it the only one that provides beginner, intermediate and mixed courses.

## Further Improvements
- Categorize course titles using frequency analysis with *collections* and *langdetect* libraries or machine learning.  

**If more data were to be available, success of the courses could be further investigated by looking at the following:**  
- Course length
- Course lifespan
- Course content
- Feedback provided from students.  
- Course value - whether course is paid or free
