[Node.js Releases](https://nodejs.org/en/about/previous-releases) - we follow the even numbered ones as time goes by. As an example, in Sep 2024 we are still 20.x and (probably a little) late moving to Node v22.x. To see the current version, look in package.json (engines/node).

# AccuTheme-Bs4

Status: no roadmap, fixes and minor improvements from now on. AccuTheme "redux" in the works (20230305 JRF).

[Maintenance](/README-maintenance.md): of THIS template project, periodic upkeep on dependencies and related

[VS Code Setup](https://www.accu4.com/H2R2S/VS-Code-Initial-Setup): from scratch, new machine, etc.

## Getting started

- [Initial setup](/README-deploy.md#initial-setup) - you are starting from scratch
- [Cloning locally](/README.md#cloning-locally) - first time adding this project to your machine
- [Next steps](../../wiki) <<< ESSENTIAL <<<

## Project requirements, recommendations

- DNN site already deployed
- [NVM-Windows](https://github.com/coreybutler/nvm-windows) to manage your Node versions
- [Node/NPM](https://nodejs.org/en) - `/package.json` Engines/Node for required versions
- TBD: do we need to initially install NodeJS package the normal way first or is it okay to only install using NVM?

### Cloning locally

#### 1. Get the code

Navigate to the directory where you want to store the project, copy the GitHub URL, and then run the following commands in your terminal:

```
git clone _GITHUB_URL_HERE_
```

#### 2. Set your FTP config

If you are using Visual Studio Code, navigate to the `.vscode/` directory. Duplicate `sftp.json.example`, configure it with your credentials, and save it as `sftp.json` to continue.

#### 3. Install and build packages

Open package.json, and remove the line under "scripts" (line 7) `"preinstall": "npx npm-force-resolutions",` and save

Next, run `npm install`. If you did not remove the line from package.json the install will fail until you do.

After the install is finished, `npm run build` will automatically run. This compiles assets (styles, scripts, etc.), but Gulp won't stay in "watch" mode.

Back in package.json, add the line `"preinstall": "npx npm-force-resolutions",` back to package.json, and save.

Run `npm install` one more time. 

#### 4. Build the assets

Run `npm start`.

This will kick off the Gulp tasks to optimize and compile assets (images, styles, scripts, etc.). It will also continue watching for changes to source files.

To exit "watch" mode, press `Control-C` in your terminal.

To start watching again, run `npm start`.

#### 5. Push changes to GitHub

Because you cloned the repository using the GitHub URL, your local repo's `origin` is properly set. However, if you get an error message when you try to push your changes up to remote, it's because you do not have permission to write to the private repo.

Make sure (1) [your GitHub credentials are correct](https://help.github.com/en/articles/caching-your-github-password-in-git), or (2) your GitHub username is added as a collaborator on this project.



<hr>

# Old roadmap, plans, and related...

The Accuraty Solutions Bootstrap 4.6 based theme starter kit for DNN projects.
 
 - [ ] customized Bootstrap with Bootstrap Icons
 - [ ] JS module bundling
 - [ ] CSS optimizations
 - [ ] media file optimizations (images, SVG, videos)
 - [ ] linting (opinionated?)
 - [ ] favicon generator, move to Webpack
 - [x] package to Dnn Zip installer (Webpack)
 - [x] converted from CJS to ESM in Sep 2021
 - [x] Node works v16.13+ LTS (Dec 2021)
 - [x] Reconfigure for multi-project (Jan 2022)
 
## Roadmap and Feature Ideas

 - improved SCSS file structure
 - improved workflow supporting Modes; deploy, setup, design, develop, staging, golive, production
 - convert monolithic Build to minimum or configurable
 - more utility tasks (like package and favicons)
 - utility to switch Modes and optionally build
 - convert Gulp tasks to Webpack (or newer??)
 - rework AccuTheme and AccuKit utilities (see JRF, AccuCode)
 - rework Env/Config/Settings for Workflow and Mode; Presets/Defaults, Client/Project, Modes
 - Boostrap v5 ??
 - TailwindCSS ?? (re-architect deploy/setup)
 
