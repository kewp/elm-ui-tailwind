# elm-ui-tailwind

Trying to build out the tailwind ui components using both Elm-UI and tailwind css.


For this to work we need to allow elm-ui to handle all the layout.
Not sure if this is going to be worth the effort.

Not sure how to break this up,
but I think doing one piece of code per tailwind ui example
will be good. I'll start with something small and build
me way up.

## section headings

Not sure this link will work in the future https://tailwindui.com/components/application-ui/headings/section-headings#component-ed0bd6107e9619f08a549f76f5073f20
but the first component in that link is a simple section heading.
Here is the html.

```html
<!-- This example requires Tailwind CSS v2.0+ -->
<div class="pb-5 border-b border-gray-200">
  <h3 class="text-lg leading-6 font-medium text-gray-900">
    Job Postings
  </h3>
</div>
```

Here is what the classes mean:

- *pb-5* padding bottom five [_layout_]
- *border-b* border bottom [_style_]
- *border-gray-200* border gray [_style_]
- *text-lg* text large [_layout_]
- *leading-6* line height 6 [_layout_]
- *font-medium* font weight medium [_style?_]
- *text-gray-900* text gray [_style_]

What important is to know which attributes affect the layout.
Does changing the font weight change the layout?

Finally, how do we translate the layout aspects to Elm-UI?
Is there a way to check if it's working (besides eye-balling it)?

## elm / elm-ui setup

getting things setup with elm / elm-ui was pretty basic.
i just ran this

```
elm init
elm install mdgriffith/elm-ui
```

and then created a file called `chat.elm`

```elm
module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)

channelPanel : Element msg
channelPanel =
    column
        [ height fill
        , width <| fillPortion 1
        , Background.color <| rgb255 92 99 118
        , Font.color <| rgb255 255 255 255
        ]
        [ text "channels" ]


chatPanel : Element msg
chatPanel =
    column [ height fill, width <| fillPortion 5 ]
        [ text "chat" ]


main : Html msg
main =
    layout [] <|
        row [ height fill, width fill ]
            [ channelPanel
            , chatPanel
            ]
```

and then ran `elm reactor`. Then I opened up `localhost:8000` and clicked on `chat.elm`
and it appeared!

This will be an easy way to test my tailwind-ui replications.

## parcel

turns out that elm reactor doesn't let you load in css files.
so we will have to do this a longer way.

it seems that `parcel` is the best way to bundle tailwind with elm.

I'm going to be following this tutorial for this https://deedop.de/blog/the-pet-stack-1

Step 1

```
npm init -y
npm i -D parcel-bundler
```

then we open `package.json` and change it thus:

```json
{
  "scripts": {
    "start": "parcel src/index.html",
    "build": "parcel build src/index.html"
  }
}
```

then I put the following into `src/index.html`

```html
<!DOCTYPE HTML>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Trying out Parcel</title>
  <!-- we are referencing our stylesheet here-->
  <link rel="stylesheet" href="./style.css">
</head>

<body>
  <!-- we will need this div later -->
  <div id="app"></div>
  <!-- we are referencing our js file here-->
  <script src="./index.js"></script>
</body>

</html>
```

Next I say

```
npm i -D elm # install the elm compiler
```

and in `src/index.js` I say

```js
import { Elm } from './Main.elm';

Elm.Main.init({ node: document.querySelector('#app') });
```

and then in `src/Main.elm` put

```elm
module Main exposing (..)

import Html exposing (h1, text)

main =
    h1 [] [ text "Hello from Elm" ]
```

and in `src/style.css` I put

```css
h1 {
  text-decoration: underline;
  background-color: lightgray;
  border-radius: 0.25rem;
  text-align: center;
  padding:  0.25rem;
}
```

Now run `npm start` and it should say "visit localhost:1234"
or some such. Visit that and you should see `Hello from Elm`.

## adding tailwind

Now run `npm i -D tailwindcss` and in `postcss.config.js` put

```js
module.exports = {
  plugins: [ require("tailwindcss") ]
};
```

Now change `src/style.css` to

```css
/* resets */
@tailwind base;

/* components */
@tailwind components;

/* utility classes */
@tailwind utilities;
```

Now `npm start` should work but

### PostCSS plugin tailwindcss requires PostCSS 8.

You need to visit https://github.com/postcss/postcss/wiki/PostCSS-8-for-end-users
which says apparently you can just update parcel to nightly to get postcss 8 support.

```
yarn add parcel@nightly
```

(It's taking forever. Might be easier to just use PostCSS 7).

Oops - turns out I was reading the error wrong... not sure why the github link came up.
This is the link to use https://tailwindcss.com/docs/installation#post-css-7-compatibility-build
which gives these instructions:

```
npm uninstall tailwindcss postcss autoprefixer
npm install tailwindcss@npm:@tailwindcss/postcss7-compat @tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9
```

## Use tailwind

Ok after that I changed `src/Main.elm` to

```elm
module Main exposing (..)

import Html exposing (h1, text)
import Html.Attributes exposing (class)

main =
    h1 [class "bg-black"] [ text "Hello from Elm" ]
```

and magically I got the black background (`bg-black` is a tailwind class).

It should hot reload as well.

## links

next we want to have links for each tailwind-ui project we are trying to
replicate.

I literally stole the code from here https://korban.net/elm/elm-ui-patterns/link
and pasted it into `src/Main.elm` (but I had to rename the module to `Main`).

```elm
module Main exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


main : Html Bool
main =
    layout [ width fill, height fill ] <|
        column
            [ width <| maximum 600 fill
            , centerX
            , centerY
            , padding 20
            , spacing 20
            ]
            [ link [] { url = "#", label = text "Unstyled link" }
            , link [ Font.bold, Font.underline, Font.color color.blue ]
                { url = "#", label = text "Styled link" }
            , text "Image link:"
            , link []
                { url = "#"
                , label =
                    image []
                        { src = "https://picsum.photos/200/100"
                        , description = "Image link"
                        }
                }
            , newTabLink [ Font.bold, Font.underline, Font.color color.blue ]
                { url = "https://example.com", label = text "New tab link" }
            , download [ Font.bold, Font.underline, Font.color color.blue ]
                { url = "/index.html", label = text "Download file" }
            , downloadAs [ Font.bold, Font.underline, Font.color color.blue ]
                { url = "/index.html", filename = "renamed.html", label = text "Download renamed file" }
            ]


color = 
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    }
```
