import 'package:eye/authentication/user_progress.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

final _quizTaking = QuizTakingBloc();

class QuestionInfo {
  String id = randomId;
  String question = 'q';
  List<String> options = [
    'a',
    'b',
    'c',
    'd',
  ];
  int answerIndex = 0;
  int? userAnswerIndex;
  bool get isAnswered => userAnswerIndex != null;
}

class QuizTakingState {
  Map<String, QuestionInfo> questions = {
    for (var info in [
      QuestionInfo()
        ..question = 'question 1'
        ..options = ['abcd ', 'sdasdsa', 'uyweghvwf', 'asodhiasdh']
        ..answerIndex = 0,
      QuestionInfo()
        ..question = '2sjhbdjsbkjasd'
        ..options = ['assadb', 'sdasdsa', 'uyweghvwf', 'afsdfsdsodhiasdh']
        ..answerIndex = 0,
      QuestionInfo()
        ..question = '3sjhbdjsbkjasd'
        ..options = ['assadb', 'sdasdsa', 'uyweghvwf', 'afsdfsdsodhiasdh']
        ..answerIndex = 0,
      QuestionInfo()
        ..question = '4sjhbdjsbkjasd'
        ..options = ['assadb', 'sdasdsa', 'uyweghvwf', 'afsdfsdsodhiasdh']
        ..answerIndex = 0,
      QuestionInfo()
        ..question = '5sjhbdjsbkjasd'
        ..options = ['assadb', 'sdasdsa', 'uyweghvwf', 'afsdfsdsodhiasdh']
        ..answerIndex = 0,
      QuestionInfo()
        ..question = '6sjhbdjsbkjasd'
        ..options = ['assadb', 'sdasdsa', 'uyweghvwf', 'afsdfsdsodhiasdh']
        ..answerIndex = 0,
    ])
      info.id: info,
  };

  int questionIndex = 0;
  QuestionInfo get question => questions.values.elementAt(questionIndex);
  String name = 'DEMO';

  ///
  int pageIndex = 0;

  int get result {
    final correctlyAnswered = questions.values.where(
      (info) {
        return info.answerIndex == info.userAnswerIndex;
      },
    ).length;
    return correctlyAnswered;
  }

  double get percentage => result / questions.length;
}

class QuizTakingRepository {}

class QuizTakingBloc extends Bloc {
  final quizTakingRM = RM.inject(() => QuizTakingState());
  QuizTakingState get state => quizTakingRM.state;
  set state(QuizTakingState value) => quizTakingRM
    ..state = value
    ..notify();
  int pageIndex([int? value]) {
    if (value != null) state = state..pageIndex = value;
    return state.pageIndex;
  }

  int questionIndex([int? value]) {
    if (value != null) {
      state = state..questionIndex = value;
      if (value >= questions().length) submit();
    }
    return state.questionIndex;
  }

  void put(QuestionInfo info) {
    state = state..questions[info.id] = info;
    // state = state..questions = (Map.of(state.questions)..[info.id] = info);
  }

  QuestionInfo get question => state.question;

  bool get inTheStart => questionIndex() == 0;

  bool get inTheEnd => questionIndex() == questions().length - 1;
  QuestionInfo? get(String id) => state.questions[id];
  Iterable<QuestionInfo> questions() => state.questions.values;
  int time = 0;

  Timer? timer;
  void start() {
    timer = Timer.periodic(
      1.seconds,
      (callback) {
        time++;
      },
    );
    questionIndex(0);
    pageIndex(1);
  }

  void nextQuestion() {
    if (questionIndex() < questions().length - 1) {
      questionIndex(questionIndex() + 1);
    }
  }

  void previousQuestion() {
    if (questionIndex() > 0) {
      questionIndex(questionIndex() - 1);
    }
  }

  UserProgress? get progress => usersRepository.currentUser.progress;

  void submit() {
    timer?.cancel();
    timer = null;
    updateUserProgress();
    pageIndex(2);
  }

  void updateUserProgress() {
    if (progress != null) {
      final progress = this.progress!;
      int quizzes = progress.quizzes;
      int totalScore = progress.totalScore;
      int totalQuestionsAttempted = progress.totalQuestionsAttempted;
      double bestPercentage = progress.best;
      final percentage = state.percentage;
      if (percentage >= bestPercentage) {
        bestPercentage = percentage;
      } else {
        bestPercentage = bestPercentage;
      }
      quizzes++;
      totalQuestionsAttempted += state.questions.length;
      totalScore += state.result;

      usersRepository.setUserProgress(
        progress
          ..quizzes = quizzes
          ..totalScore = totalScore
          ..totalQuestionsAttempted = totalQuestionsAttempted
          ..lastQuizDate = DateTime.now()
          ..best = bestPercentage,
      );
    } else {
      usersRepository.setUserProgress(UserProgress());
      updateUserProgress();
    }
  }

  /// 📌 Resets quiz-taking state
  void reset() {
    pageIndex(0);
    questionIndex(0);
  }
}

class QuizTakingPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Quiz Taking'.text(),
        actions: [
          FHeaderAction.back(onPress: _quizTaking.back),
        ],
      ),
      content: IndexedStack(
        index: _quizTaking.pageIndex(),
        children: [
          initial(),
          test(),
          success(),
        ],
      ),
    );
  }

  Widget initial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _quizTaking.state.name.text(textScaleFactor: 2).pad(),
        Expanded(
          child: 'Questions: ${_quizTaking.questions().length}'.text().pad(),
        ),
        FButton(
          onPress: _quizTaking.start,
          label: 'Start Quiz'.text(),
        ).pad(),
      ],
    ).center();
  }

  /// 📌 Success Page: Shows quiz result summary
  Widget success() {
    return Column(
      children: [
        'Quiz Completed!'.text().pad(),
        'Time Taken: ${_quizTaking.time} seconds'.text(),
        'Correct Answers: ${_quizTaking.state.result}'.text(),
        'Wrong Answers: ${_quizTaking.questions().length - _quizTaking.state.result}'
            .text(),
        '${_quizTaking.state.result}/${_quizTaking.questions().length}'
            .text()
            .pad(),
        FButton(
          onPress: () {
            _quizTaking.reset();
          },
          label: 'Retry'.text(),
        ).pad(),
        FButton(
          onPress: _quizTaking.back,
          label: 'Home'.text(),
        ).pad(),
      ],
    ).center();
  }

  Widget test() {
    final _index = _quizTaking.questionIndex();
    final _length = _quizTaking.questions().length - 1;
    final progress = _index / _length;
    return Column(
      children: [
        FProgress(value: progress).pad(),
        _quizTaking.question.question.text().pad(),
        FTile(
          title: 'Unanswer this question'.text(),
          onPress: () {
            _quizTaking.put(_quizTaking.question..userAnswerIndex = null);
          },
        ),
        FTileGroup.builder(
          divider: FTileDivider.full,
          count: _quizTaking.question.options.length,
          tileBuilder: (_, index) {
            return FTile(
              suffixIcon: _quizTaking.question.userAnswerIndex == index
                  ? FIcon(
                      _quizTaking.question.answerIndex ==
                              _quizTaking.question.userAnswerIndex
                          ? FAssets.icons.check
                          : FAssets.icons.cross,
                    )
                  : null,
              enabled: !_quizTaking.question.isAnswered,
              title: _quizTaking.question.options[index].text(),
              onPress: () {
                _quizTaking.put(
                  _quizTaking.question..userAnswerIndex = index,
                );
                _quizTaking.nextQuestion();
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FButton(
              onPress: _quizTaking.inTheStart
                  ? null
                  : () {
                      _quizTaking.previousQuestion();
                    },
              label: 'Previous'.text(),
            ).pad(),
            FButton(
              onPress: _quizTaking.inTheEnd
                  ? null
                  : () => _quizTaking.nextQuestion(),
              label: 'Next'.text(),
            ).pad(),
            FButton(
              onPress: _quizTaking.submit,
              label: 'Submit'.text(),
            ).pad(),
          ],
        )
      ],
    );
  }
}
