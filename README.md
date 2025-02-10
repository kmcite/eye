ophthalmology [eye]
🟨🟥
1. login page
    1. 🟨 login button
    2. 🟨 email & password fields
    3. 🟨 login button & navigation to register page button

2. register page
    1. register button
    2. username/id, email & password fields
    3. register button & navigation to login page button

3. dashboard page
    1. attempt to take demo quiz [demo]
    2. list of quizzes
        1. built-in
        2. user created
    3. navigate to questions page
    4. navigate to settings page
    <!-- 5. details about progress of different quizzes -->

4. questions page [admin]
    1. all questions available
    2. menubar -> selecting [edit,read] mode
    3. on tapping each question, navigate to question page [admin]
        1. question content
        2. options
        3. answer
        4. explanation
        5. demo (bool)
5. settings page
    1. user management
        1. name
        2. password
        3. email / id
        4. profile picture
        5. date of birth / age
        6. user quiz taking history     
        7. custom quizzes created by user   
        8. logout / delete account (no restore possible)
    2. theme mode

6. quiz taking page
    1. multiple pages
        starting page
        question page
        results page


[Question]
id
content
options -> [list of options]
answer
explaination
demo (bool)

[EyeUser]
id
admin -> bool
name
uid -> firebase_auth_id
email -> from firebase or custom
profile picture url
date of birth
quizzes created by user
quizzes taken by user


[Quiz]
id 
name
list of questions
mode


2. Question Database (Firestore or Firebase Realtime Database)
Question Model: Store all question data, including:
questionText: Main question content.
options: List of possible answers.
correctAnswer: Correct answer for evaluation.
explanation: Detailed explanation of the answer.
isDemo: Boolean to flag demo questions.
chapter: Category/Chapter for organizing questions.
Categories: Group questions by chapters or specific topics using the chapter field.
3. Quiz System
Global Quizzes:
Created by the app owner and accessible to all users.
Metadata includes title, category, and totalQuestions.
Custom Quizzes:
Users can generate custom quizzes by selecting filters like chapters and difficulty.
User Quiz History:
Stores a log of completed quizzes with:
Timestamps, scores, and question-specific answers for later review.
4. Quiz Taking Modes
Study Mode:
For practice, allowing hints and immediate feedback after each question.
Exam Mode:
Strict timing and scoring without immediate feedback.
Timer:
Countdown timer for each mode, tracking quiz duration.
Progress Tracking:
During the quiz, display stats for:
Total Questions
Answered
Unanswered
5. Answer Review & Explanations
Post-Quiz Review:
After quiz submission, users can review each answer, with:
Correct answers, detailed explanations, and optional discussion sections.
Bookmarks & Flags:
Users can bookmark challenging questions for focused review.
