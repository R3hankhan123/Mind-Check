
# Mind Check

## Inspiration
Social media is often considered a boon for the society but it has a darker side primarily the addiction it causes. This addiction often causes depression, anxiety and inferiority complex due to the nature of the post often posted. This web app provides a comprehensive solution to combat these ill effects of social media.

## What does it do?
Our web app provides a platform for users to express how they are feeling to a chatbot and depending on the response the user may continue chating with the chatbot or may consult a therapist

## How we built it?
Our AI chatbot is built on Da-Vinci-003 text model and we have used openai API's and gradio( for web interface) and have deployed it on huggingface spaces.The frontend was made using flutter and firebase was used for authentication and database.In addition to that services from apyhub and twilio. A registery name was acquired from Godaddy registry (mind-check.co)

## Challenges we ran into
Earlier we tried to use interface method for creating gradio application which gave alot of problems but later we swithced to block method which was less prone to bugs. Another challenge we ran into was deployment of the chatbot. Initially we tried using azure to deploy the chatbot but it kept giving 500 error code. It was solved by using huggingface spaces. Another problem was with the security nature of chrome and chromium based browsers having security issues with apyhub api's. For the local build it was easily solved by disabling --disable-web-security but that couldn't be disabled while deploying the web app to firebase

## Accomplishments that we're proud of
We are proud of being able to make a chatbot which was our dream ever since the chatgpt was released for the public. We are also proud of being able to deploy a web app on huggingface spaces

## What we learned
The main thing we learned was how azure worked and how models could easily be trained on it using AutoML

## What's next for Mind Check
The main thing in the future for Mind Check is to improve the chatbot and the ability for the app to read a user's social media posts on receiving his convent# Mind-Check
# Mind-Check
