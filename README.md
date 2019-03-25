# Welcome to GitHubBrowser

GitHub Browser is an iOS app which allows you to search for repositories and view the commit history of those repositories on an iOS device.

## What is this repository good for? 

If you're interested in hiring its author, it's a good starting point for evaluating his coding skills (though I'd still recommend an in-person interview 😉). 

 If you're new to iOS development or have never used a GraphQL api before, then you can use this as an example to learn from (but look at lots of examples, everbody makes different compromises in development and you should learn from lots of different people).
 
## How to use this repository:
If you clone this repository and immediately try to run it, you won't be able to browse anything.  That's because GitHub's API requires an access token, and I didn't want to put my personal access token up on a public repository.

To use your own personal access token with this app, create an enviromnment variable in your clone of the repository with **"github-access-token"** as the name and your actual access token as the value.

If you're not sure how to set environment variables, instructions can be found [here](https://nshipster.com/launch-arguments-and-environment-variables/).

If you're not sure how to generate a personal access token, instructions can be found [here](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line).  I recommend keeping the scope of your access token as limited as you can in case your token is ever leaked or made public. If you only want/need to view public repositories (yours or someone else's), you can uncheck all of the scope boxes when you create your repository; this will limit the motivation and potential for others to abuse your token.

If you want to actually publish an app based on this repository and not just launch it from Xcode, you will have to create your own implementation of `TokenProvider` that gets your access token from somewhere other than an environment variable. Be careful about hard-coding it into your app, as that's a good way to get your token leaked.

## Explainations of some of the decisions that went into this repository:
1. Using a Coordinator instead of Storyboards: 
  * Storyboards are notorious for creating merge conflicts. Although this project is small enough and currently just has one developer, I don't like to get into the habit of using storyboards.
  * Storyboards encourage code of individual `ViewControllers` to be too tied to navigation and any `ViewController`s. `Coordinators` mean `ViewController`s don't need to know anything about each other.
2. The `Coordinator` knows about network calls?
  * Normally, a `Coordinator` should be responsible soley for navigation and not know anything about network calls. However, since this app is quite small, introducing another class to mediate between the `ViewController` and and `GitHubAPI` wasn't worth the complexity tradeoff. Since the `ViewController`s still have simple protocols for their interfaces, it would be easy to drop another object in their later if the `Coordinator` ever starts to become too complicated.
3. GitHub has a perfectly good REST API, why use the GraphQL API?
  * In principle, like to use the latest version of the API when I make a new project.
  * The GraphQL API allows for super fast and lightweight network calls because the responses don't contain any information I didn't specifically ask for.
4. Why not use Codable to parse the network responses?
  * Codable is great for parsing responses from REST APIs where the responses are usually objects in the traditional sense.  The implementation required to use Codable to parse GraphQL responses was very bloated, whith lots of `CodingKeys` enums or entire `struct`s whose sole purpose is to pull a singe entry out of a dictionary.