# transmuting women's height into men's
# multiply 1.08 (1.07~1.09) or add 5.11" (4.91~5.31")
# use galton's original data

library(shiny)

shinyUI(pageWithSidebar(
  headerPanel(h3('Conversion of female heights to male equivalents')),
  sidebarPanel(
    strong('Please choose the conversion method and constant here.
            After the selection, press the Submit button for the recalculation.'),
    br(), br(),
    radioButtons('model','Transmutation model:',
                 c("Multiplicative",
                   "Additive")),
    br(),
    sliderInput("constant","Conversion factor:",
                 min=0, max=1, value=0.5, step=0.1),
    em('The slider runs from 1.07 to 1.09 for multiplicative model,
        and 4.91 to 5.31 inches for additive model.
        Ranges are inferred from GaltonFamiles dataset.'),
    br(), br(),
    submitButton('submit')
  ),
  mainPanel(
    h4('About this app:'),
    p('In his seminal paper, Galton converted female heights to male equivalents by multiplying 1.08.
       For more information, please refer to the documentation and references accompanying GaltonFamilies{HistData} dataset.
       However, some people prefer simply adding some inches for the conversion (for example, 5.2 inches).
       In this app, we revisit GaltonFamilies dataset to explore the correlation of parent and child using these different conversion methods.
       You can manipulate the left side panel to fit a simple linear model.'),
    br(),
    h4('Your input:'),
    verbatimTextOutput('oid1'),
    br(),
    h4('Regression results:'),
    plotOutput('oid2'),
    br(),
    h4('Residual plot:'),
    plotOutput('oid3')
  )
))