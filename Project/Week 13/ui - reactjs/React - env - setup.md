# React JS :zap:

> Environment Setup :file_cabinet:

- We need to setup required environment to start working with React and other libraries (data-driven forms for now).

- Install `Nodejs`. You should have homebrew's `brew` package manager to install node on os x.
    ```sh
    brew install node
    ```
- Install `react` & `react-dom` packages through `npm` - package manager for node.
    ```sh
    npm install -g react react-dom
    ```
- Install`create-react-app` tool using `npx` to able to create new react applications easily
    ```sh
    npx create-react-app <app-name>
    cd <app-name>
    npm start
    ```
    `npx` is a package runner tool that comes with `npm`. `npm start` starts up the realtime server from where we can able to see the preview of our application and test it. Default port is `3000`.

- Edit the `<app-name>/src/App.js` file to make any changes that you want to make and verify on the realtime preview.
