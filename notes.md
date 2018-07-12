Para resolver o problema dos rótulos do eixo x:

https://stackoverflow.com/questions/28915328/how-to-set-x-axis-in-dygraphs-for-r-to-show-just-month/28918684
https://www.w3schools.com/jsref/jsref_obj_date.asp
https://stackoverflow.com/questions/46756661/my-dygraph-is-not-responsive-in-a-flexdashboard-output-doesnt-resize-itself-t


```
        dyAxis("x", axisLabelFormatter=JS('function(d){d.getFullYear()};')
```

Tentar embrulhar o dygraph num div, com as regras:
width: 100%;
max-width: alguma coisa em px.
height: auto;
