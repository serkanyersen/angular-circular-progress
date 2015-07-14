# D3 & AngularJS Circular Progress Bar
This is an experiment on AngularJS, CoffeeScript and D3.js.
It creates a directive that takes two values `actual` and `expected`
and draws a circular progress bar.  
**Demo:** http://labs.serkan.io/d3-progress/

<p align="center">
<img src="http://i.imgur.com/AJ06AWE.png" />
</p>

## installing & running
Checkout the project then go into the folder and run

```
npm install
```

After all packages are installed you can now build or run development server

### Build
```
grunt build
```

Builds the project to `/dist` folder where you can statically serve it

### Develop
```
grunt server
```

Runs a static web server with livereload support. While this command is running you can simply open the project
on browser and start editing files. It will automatically build itself and reload the page for you.

### Tests
```
npm test
```

Will run the karma test runner once and print the output

```
karma start --reporters=dots
```

Will keep the test runner alive so you can do your development while tests are running

PS: you may need to install `karma-cli` and `grunt-cli`
