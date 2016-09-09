module CommentList exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import VirtualDom exposing (Node, Property)
import Types exposing (..)
import Formatting exposing (formattedTime)

view : Model -> Html a
view model =
  div [] [
    renderCommentSettings
  , renderCommentList(model)
  ]

renderCommentSettings : Node a
renderCommentSettings =
  div [ class "comment-settings" ] [
    renderOption "Comments I wrote"
  , renderOption "Comments on others"
  , renderOption "Resolved comments"
  ]

renderOption : String -> Node a
renderOption name =
  label [] [
    input [ type' "checkbox" ] []
  ,  text name
  ]

renderCommentList : Model -> Node a
renderCommentList model =
  if (List.length model.comments) == 0 then
    text "There are no comments yet! Write some."
  else
    ul [ class "comments-list" ] (List.map (renderComment model) model.comments)

renderComment : Model -> Comment -> Node a
renderComment model comment =
  li [ id (commentId comment), (commentClassList comment) ] [
    a [ class "block-link" ] [
      div [ class "comment-proper" ] [
        div [ class "comment-proper-author" ] [
          div [ class "comment-controls" ] [
            button [ class "small mark-as-resolved" ] [
              i [ class "fa fa-eye" ] [ text "Mark as resolved" ]
            ]
          ]
        , img [ class "comment-proper-author-gravatar", src "" ] []
        , i [ class "fa fa-chevron-right commenter-to-committer-arrow" ] []
        , img [ class "comment-commit-author-gravatar", src "" ] []
        , strong [] [ text comment.authorName ]
        , text " on "
        , span [ class "known-commit" ] [
            em [ class "comment-commit-summary" ] [ text "Commit summary" ]
          ]
        , text " on "
        , span [] [ text (formattedTime comment.timestamp) ]
        ]
      , div [ class "comment-proper-body" ] [
          text "todo: implement comment listing"
        ]
      ]
    ]
  ]

commentClassList : Comment -> Property a
commentClassList comment =
  -- TODO: logic and tests
  classList [
    ("your-last-clicked", False)
  , ("authored-by-you", False)
  , ("on-your-commit", True)
  , ("is-resolved", False)
  , ("test-comment", True)
  ]

commentId : Comment -> String
commentId comment =
  "comment-" ++ toString comment.id
