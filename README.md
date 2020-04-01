# STA 323 :: Exam 2

## Introduction

<i>
Twenty million veterans live in the United States. They live in every state 
and in nearly every county across the nation. About 5 million veterans lived in 
areas designated as rural by the U.S. Census Bureau during the 2011–2015 period. 
Understanding who rural veterans are and what sets them apart from other 
veterans, as well as from their rural neighbors, provides the necessary 
perspective for rural communities, government agencies, veterans’ advocates, 
and other policymakers interested in directing programs and services to this 
population.

The U.S. Department of Veterans Affairs (VA) has identified veterans living in 
rural areas as a population of interest. To help address concerns of veterans’ 
access to care, Congress established the Office of Rural Health within the VA 
in 2007. One challenge in these efforts is that most of the data available to 
the VA come only from rural veterans enrolled in their healthcare system, and 
not all veterans are enrolled. However, to anticipate demand for care, as well 
as to understand what types of services may be requested or utilized, requires 
data on all rural veterans.

[This brief](https://www.census.gov/content/dam/Census/library/publications/2017/acs/acs-36.pdf) 
aims to answer the question “Who are rural veterans?” by considering 
the demographic, social, and economic characteristics of rural veterans 
compared with both urban veterans as well as with rural nonveterans. It also 
examines rural veterans by the level of rurality of their county of residence 
to understand some of the impact of geography on their characteristics. The 
data used in this report are primarily from 2011–2015 American Community Survey 
(ACS), 5-year estimates. This report presents statistics about veterans and, 
where applicable, nonveterans 18 years and older living in rural and urban 
areas of the United States.
</i>

<b>
REPORT NUMBER ACS-36
</br>
KELLY ANN HOLDER
</b>
</br></br>

To read the full brief and get some inspiration for this Exam click 
[here](https://www.census.gov/content/dam/Census/library/publications/2017/acs/acs-36.pdf).

## Data

<b>Data and Exam 2 overview [video]()</b>

In your repository is an Excel file `rural_veterans/data/rural_vets.xlsx`. 
There are three tables in this file (one in each tab). Footnotes are available 
at the bottom of the tables.

Table 1. Selected Characteristics of Veterans by State and Urban/Rural Residence

Table 2. Poverty Statistics for Veterans, by State and Urban/Rural Residence

Table 3. Employment Characteristics for Working-Age Veterans, by State and 
		 Urban/Rural Residence

The data is not in the nicest form for reading it directly into R. However, 
you may manipulate the Excel file (or change to another file type) before you 
read it into R. Save your modified file as `rural_vets_clean` in
`rural_veterans/data/`.
   
## Tasks

You may use any R package. Include code to load your package with 
`library(package_name)`. If I do not have the package, I will install it.

#### Task 1

Use the provided data (you may select of subset of the data - not all three
tables need to be used) to create a Shiny app or dashboard that allows users
to interact, explore, and better understand the data. You may want to 
work with the [Navigation Bar Page](https://shiny.rstudio.com/gallery/navbar-example.html)
layout or [shinydashboard](https://rstudio.github.io/shinydashboard/). Both 
options will neatly structure your UI; however, these are not the only options.

Required app features:

1. An information section - what is the data, where did it come from, what is
   the purpose. Including something akin to the Introduction above is sufficient.
   Make it clear to users what data they are exploring.

2. It should have at least three input/control widgets.

3. It should have at least three reactive output displays. 

4. It should incorporate at least one derivative shiny package such as 
   `shinythemes` or `shinyalert`. There are many more, these are just two 
   examples.

5. It should be well organized and aesthetically pleasing.

Satisfying these requirements will earn you at least half the points allocated
for Task 1. The remaining points will be awarded based on your creativity,
effort level, and how well your app functions (think about using action buttons
and/or reactive expressions for efficiency and a pleasant user experience). 

So, be creative and feel free to incorporate other data including spatial data. 
Check out Shiny's [gallery](https://shiny.rstudio.com/gallery/) for inspiration.

#### Task 2

Publish your app on https://www.shinyapps.io/.

#### Task 3

Modify this README.

1. Change the title from `STA 323 :: Exam 2` to something
   more meaningful as it relates to your app.

2. Remove all other text but the introduction and references sections and their
   respective text.

3. Add a link to your app that you published in Task 2.

4. Add any other relevant information to this README that someone looking at
   your repo may be interested in knowing. This can be text or images.

## Essential details

#### Deadline and submission

**The deadline to submit Exam 2 is 11:59pm EST on Wednesday, April 8.** 
Only the code in the master branch will be graded.

#### Rules

- This is an individual assignment.

- Everything in your repository is for your eyes only except for the 
  instructor and TAs.

- You may not communicate anything about this exam to anyone.

- You may use any online, book, and note resources. As always, you must cite 
  any code you use as inspiration.

- Questions should only be about understanding the data or the exam's 
  instructions.

#### git / GitHub

You will only have one branch to start with in your repository - master. 
You may create other branches as needed, but only your work in the master 
branch will be graded. Be sure to push your work before the deadline.

#### Academic integrity

This is an individual assignment. See the Rules section above.
As a reminder, any code you use directly or as inspiration must be cited.

To uphold the Duke Community Standard:

- I will not lie, cheat, or steal in my academic endeavors;
- I will conduct myself honorably in all my endeavors; and
- I will act if the Standard is compromised.

#### Grading

A portion of the total points for each task will be allocated towards
efficiency and code style.

**Topic**|**Points**
---------|----------:|
Task 1   |  46
Task 2   |   6
Task 3   |   8
**Total**|**60**

*Apps that fail to run after minimal intervention will receive a 0*.

## References

- Bureau, U. (2018). Veterans in Rural America: 2011–2015. The United States 
  Census Bureau. Retrieved 20 March 2020, 
  from https://www.census.gov/library/publications/2017/acs/acs-36.html
