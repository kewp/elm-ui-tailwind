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