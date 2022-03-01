# clerk-sdk-godot
> **Unofficial Clerk.dev frontend API for Godot Engine.**

The purpose at this stage is proof of concept. I intend to build the Godot scenes to be more stand alone so that you can drag and drop certain components, or easily access specific data about your authenticated user.

# Getting Started
1. Register and login to your dashboard at https://clerk.dev
2. Add and Create a new Application, keep the Password option selected.
3. Navigate to *API Keys* under Deploy.
4. Take note your Frontend API KEY. It should look like `clerk.united.grizzon-22.lcl.dev`
5. Download this repository as a ZIP, and place the `addons` folder at the root of your project.
6. From the root directory, navigate to `addons/clerk/scripts/ClerkSDK.gd` and update the FRONT_END_API to be your personal frontend API key.
7. Drag the pre built component at `addons/clerk/scenes/components/Login.tscn` into your game to see the example component in place. From this Login scene, you should be able to Sign In, Sign Up, and view your Profile.


