<%@ Page Title="Placement Quiz" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PlacementQuiz.aspx.cs" Inherits="IndoSlang.PlacementQuiz" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .quiz-wrapper {
            min-height: calc(100vh - 68px);
            background: var(--cream);
            padding: 24px 20px 40px;
            font-family: var(--font-body);
            color: var(--brown);
        }

        .quiz-inner {
            max-width: 680px;
            margin: 0 auto;
        }

        /* header */
        .quiz-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
            text-align: center;
        }

        .quiz-header-text { flex: 1; }

        .quiz-badge {
            display: inline-block;
            background: var(--accent);
            color: #fff;
            font-family: var(--font-display);
            font-size: 0.8rem;
            padding: 3px 14px;
            border-radius: 20px;
            margin-bottom: 6px;
        }

        .quiz-header h1 {
            font-family: var(--font-display);
            font-size: 1.7rem;
            margin: 0 0 4px;
            color: var(--brown);
        }

        .quiz-header p {
            color: var(--brown-mid);
            font-size: 0.85rem;
            margin: 0;
        }

        @keyframes floatBob {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        /* progress */
        .progress-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
        }

        .progress-bar-wrap {
            flex: 1;
            background: var(--cream-mid);
            border-radius: 99px;
            height: 8px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            background: var(--accent);
            border-radius: 99px;
            transition: width 0.4s ease;
        }

        .progress-count {
            font-size: 0.8rem;
            color: var(--brown-mid);
            font-weight: 700;
            white-space: nowrap;
        }

        /* question card — compact */
        .question-card {
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 18px;
            padding: 22px 26px 18px;
            box-shadow: 0 4px 20px rgba(59,42,26,0.08);
            margin-bottom: 14px;
        }

        .question-number {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--accent);
            margin-bottom: 10px;
        }

        /* plain sentence context */
        .question-context {
            background: var(--cream-mid);
            border-left: 4px solid var(--accent);
            padding: 8px 14px;
            border-radius: 0 8px 8px 0;
            font-style: italic;
            font-size: 0.88rem;
            color: var(--brown-mid);
            margin-bottom: 12px;
        }

        /* chat bubble card */
        .chat-card {
            background: var(--cream);
            border: 1.5px solid var(--cream-mid);
            border-radius: 12px;
            padding: 12px 14px;
            margin-bottom: 12px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .chat-row {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .chat-name {
            font-size: 0.68rem;
            font-weight: 700;
            color: var(--accent);
        }

        .chat-bubble {
            background: #fff;
            border: 1.5px solid var(--cream-mid);
            border-radius: 0 10px 10px 10px;
            padding: 6px 12px;
            font-size: 0.85rem;
            color: var(--brown);
            width: fit-content;
            max-width: 85%;
            line-height: 1.4;
        }

        /* social card */
        .social-card {
            background: var(--cream);
            border: 1.5px solid var(--cream-mid);
            border-radius: 12px;
            padding: 10px 14px;
            margin-bottom: 12px;
        }

        .social-label {
            font-size: 0.68rem;
            font-weight: 700;
            color: var(--brown-mid);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 6px;
        }

        .social-text {
            font-size: 0.88rem;
            color: var(--brown);
            line-height: 1.5;
            font-style: italic;
        }

        .question-text {
            font-family: var(--font-display);
            font-size: 1.1rem;
            margin-bottom: 14px;
            line-height: 1.4;
            color: var(--brown);
        }

        .options-list {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .option-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            background: var(--cream);
            border: 2px solid var(--cream-mid);
            border-radius: 10px;
            cursor: pointer;
            font-size: 0.88rem;
            color: var(--brown);
            text-align: left;
            transition: border-color 0.2s, background 0.2s;
            width: 100%;
            font-family: var(--font-body);
        }

        .option-btn:hover { border-color: var(--accent); background: #fdf4ea; }
        .option-btn.selected { border-color: var(--accent); background: #fce9d0; }

        .option-btn.opt-lost { color: var(--brown-mid); font-style: italic; }
        .option-btn.opt-lost.selected { border-color: var(--brown-mid); background: #f0ece6; }

        .option-letter {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: var(--cream-mid);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-display);
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--brown-mid);
            flex-shrink: 0;
            transition: background 0.2s, color 0.2s;
        }

        .option-btn.selected .option-letter { background: var(--accent); color: #fff; }
        .option-btn.opt-lost.selected .option-letter { background: var(--brown-mid); color: #fff; }

        .quiz-nav {
            display: flex;
            justify-content: flex-end;
        }

        .btn-next {
            background: var(--accent);
            color: #fff;
            border: none;
            padding: 11px 28px;
            border-radius: 10px;
            font-family: var(--font-display);
            font-size: 0.95rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }

        .btn-next:hover { background: var(--accent-light); transform: translateY(-2px); }
        .btn-next:disabled { opacity: 0.4; cursor: default; transform: none; }

        /* result card */
        .result-card {
            display: none;
            background: #fff;
            border: 2px solid var(--cream-mid);
            border-radius: 24px;
            padding: 48px 40px;
            text-align: center;
            box-shadow: 0 8px 40px rgba(59,42,26,0.10);
        }

        .result-mascot {
            width: 100px;
            height: 100px;
            margin: 0 auto 12px;
            animation: floatBob 3s ease-in-out infinite;
        }

        .result-mascot img { width: 100%; height: 100%; object-fit: contain; }

        .result-card h2 {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            margin-bottom: 6px;
        }

        .result-score {
            font-size: 3rem;
            font-family: var(--font-display);
            color: var(--accent);
            margin: 10px 0;
        }

        .result-level-badge {
            display: inline-block;
            background: var(--brown);
            color: #fff;
            font-family: var(--font-display);
            font-size: 1rem;
            padding: 6px 22px;
            border-radius: 20px;
            margin-bottom: 16px;
        }

        .level-strip {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .level-pill {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
            background: var(--cream-mid);
            color: var(--brown-mid);
            font-family: var(--font-display);
        }

        .level-pill.active { background: var(--accent); color: #fff; }

        .result-desc {
            color: var(--brown-mid);
            font-size: 0.92rem;
            line-height: 1.7;
            margin-bottom: 14px;
            max-width: 460px;
            margin-left: auto;
            margin-right: auto;
        }

        .result-start-module {
            background: var(--cream-mid);
            border-radius: 10px;
            padding: 12px 18px;
            font-size: 0.88rem;
            color: var(--brown-mid);
            margin-bottom: 28px;
            display: inline-block;
        }

        .result-start-module strong { color: var(--brown); }

        .result-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-register-now {
            background: var(--brown);
            color: #fff;
            border: none;
            padding: 13px 32px;
            border-radius: 12px;
            font-family: var(--font-display);
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }

        .btn-register-now:hover { background: var(--brown-mid); transform: translateY(-2px); }

        .btn-retake {
            background: var(--cream-mid);
            color: var(--brown);
            border: 2px solid var(--brown-mid);
            padding: 12px 24px;
            border-radius: 12px;
            font-family: var(--font-display);
            font-size: 0.95rem;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-retake:hover { background: #e8ddd0; }
        .hidden-server-btn { display: none; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfScore" runat="server" />
    <asp:HiddenField ID="hfLevel" runat="server" />
    <asp:HiddenField ID="hfModule" runat="server" />
    <asp:Button ID="btnSaveQuiz" runat="server" CssClass="hidden-server-btn" Text="Save" OnClick="btnSaveQuiz_Click" />

    <div class="quiz-wrapper">
        <div class="quiz-inner">

            <div class="quiz-header" id="quizHeader">
                <span class="quiz-badge">Placement Quiz</span>
                <h1>How much do you know?</h1>
                <p>12 questions — just be honest, no wrong vibes here!</p>
            </div>

            <div class="progress-wrap" id="progressWrap">
                <div class="progress-bar-wrap">
                    <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
                </div>
                <div class="progress-count" id="progressCount">1 / 12</div>
            </div>

            <div id="quizArea">
                <div class="question-card" id="questionCard">
                    <div class="question-number" id="qNumber">Question 1</div>
                    <div id="qContext"></div>
                    <div class="question-text" id="qText"></div>
                    <div class="options-list" id="qOptions"></div>
                </div>
                <div class="quiz-nav">
                    <button type="button" class="btn-next" id="btnNext" onclick="nextQuestion()" disabled>Next &#x2192;</button>
                </div>
            </div>

            <div class="result-card" id="resultCard">
                <div class="result-mascot" id="resultMascot">
                    <img id="resultMascotImg" src="Images/OWI SPARKLE EYE BIG.png" alt="OWI" />
                </div>
                <h2 id="resultTitle">Quiz Complete!</h2>
                <div class="result-score" id="resultScore">0/12</div>
                <div class="level-strip">
                    <div class="level-pill" id="pill1">&#x1F331; Beginner</div>
                    <div class="level-pill" id="pill2">&#x1F4D7; Elementary</div>
                    <div class="level-pill" id="pill3">&#x1F4D8; Intermediate</div>
                    <div class="level-pill" id="pill4">&#x1F4D5; Advanced</div>
                </div>
                <div class="result-level-badge" id="resultLevelBadge">Beginner</div>
                <p class="result-desc" id="resultDesc"></p>
                <div class="result-start-module">
                    &#x1F4CD; You'll start at <strong id="startModuleName">Module 1</strong>
                </div>
                <br />
                <div class="result-actions">
                    <button type="button" class="btn-retake" onclick="retakeQuiz()">&#x21A9; Retake Quiz</button>
                    <button type="button" class="btn-register-now" onclick="submitQuizResult()">Save my level &amp; Register &#x2192;</button>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var questions = [
            // Q1-Q3: Pure Vocabulary
            {
                contextType: 'none',
                question: "What does 'Gabut' mean?",
                options: ["Very hungry", "Bored with nothing to do", "Super excited", "In a hurry", "No idea"],
                correct: 1
            },
            {
                contextType: 'none',
                question: "What does 'Mager' mean?",
                options: ["Feeling sick", "Super happy", "Lazy to move", "Very busy", "No idea"],
                correct: 2
            },
            {
                contextType: 'none',
                question: "What does 'Baper' mean?",
                options: ["Getting too emotional about something", "Feeling confident", "Being very hungry", "Acting cool", "No idea"],
                correct: 0
            },

            // Q4-Q6: Word in a Sentence
            {
                contextType: 'plain',
                context: '"Skuy ke mall, gua traktir!"',
                question: "What is this person saying?",
                options: ["The mall is too far", "Let's go to the mall, my treat", "I don't want to go to the mall", "The mall is closed today", "I can't figure this out"],
                correct: 1
            },
            {
                contextType: 'plain',
                context: '"Santuy aja, belum terlambat kok"',
                question: "What does this sentence mean?",
                options: ["You're already too late", "Hurry up right now", "Relax, you're not late yet", "I'm running late", "I can't figure this out"],
                correct: 2
            },
            {
                contextType: 'plain',
                context: '"Gabut nih, ada yang mau nonton bareng?"',
                question: "What is this person looking for?",
                options: ["Someone to eat with", "Someone to watch something with because they are bored", "A place to sleep", "Someone to help them study", "I can't figure this out"],
                correct: 1
            },

            // Q7-Q9: Chat Conversation
            {
                contextType: 'chat',
                context: [
                    { name: 'Dira', msg: 'Eh gaskeun nonton malem ini?' },
                    { name: 'Tari', msg: 'Gas! Tapi gue mager jemput lo' },
                    { name: 'Dira', msg: 'Yaudah gue yang ke sana deh' }
                ],
                question: "What did they agree on?",
                options: ["They cancelled the plan", "Tari will pick up Dira", "They're watching tonight, Dira will go to pick up Tari", "They'll each watch from their own homes", "Too much slang, I'm lost"],
                correct: 2
            },
            {
                contextType: 'chat',
                context: [
                    { name: 'Raka', msg: 'Bro lo baper banget deh sama dia' },
                    { name: 'Yusuf', msg: 'Ngga lah, gue santuy aja' },
                    { name: 'Raka', msg: 'Wkwk yakin?' }
                ],
                question: "What is Raka suggesting about Yusuf?",
                options: ["Yusuf is angry at someone", "Yusuf has feelings for someone and is being emotional about it", "Yusuf is very tired", "Yusuf is hiding something serious", "Too much slang, I'm lost"],
                correct: 1
            },
            {
                contextType: 'chat',
                context: [
                    { name: 'Nadia', msg: 'Malam ini nongs yuk?' },
                    { name: 'Cia', msg: 'Gabut sih, tapi mager keluar' },
                    { name: 'Nadia', msg: 'Yaudah ke rumah gue aja, santuy' },
                    { name: 'Cia', msg: 'Gas!' }
                ],
                question: "What did they end up deciding?",
                options: ["They stayed home separately", "Cia is going to Nadia's house to hang out", "They're going out to a cafe", "They cancelled because Cia was too lazy", "Too much slang, I'm lost"],
                correct: 1
            },

            // Q10-Q12: Social Media / Real World
            {
                contextType: 'social',
                contextLabel: 'Instagram Caption',
                context: '"Auto mager nonton video ini, tapi relate banget sumpah"',
                question: "What is the person saying about the video?",
                options: ["The video made them want to get up and do something", "The video is confusing and unrelatable", "The video made them feel lazy but they completely related to it", "They didn't finish watching the video", "This is too advanced for me"],
                correct: 2
            },
            {
                contextType: 'social',
                contextLabel: 'Instagram Comment',
                context: '"Goks sih ini, auto baper pas bagian akhirnya gue gabut nonton ulang berkali-kali"',
                question: "What is the person saying about the video?",
                options: ["They hated it and found it boring", "They thought it was impressive, got emotional at the end, and kept rewatching", "They only watched the ending", "They were confused the whole time", "This is too advanced for me"],
                correct: 1
            },
            {
                contextType: 'chat',
                contextLabel: 'WhatsApp Group — Aldi, Bimo, Cika, Dian',
                context: [
                    { name: 'Aldi', msg: 'Eh besok pada bisa gaskeun ke pantai?' },
                    { name: 'Bimo', msg: 'Gas sih tapi gue mager banget prepare' },
                    { name: 'Cika', msg: 'Santuy, gue yang handle semua' },
                    { name: 'Dian', msg: 'Bet, gue siap. Skuy jam 7 pagi' },
                    { name: 'Bimo', msg: 'Goks, jam 7? Baper gue' }
                ],
                question: "What is actually happening in this conversation?",
                options: ["They're planning a beach trip and everyone is going", "They're cancelling because Bimo is too lazy", "Only Cika and Dian are going, the others backed out", "They haven't decided anything yet", "This is too advanced for me"],
                correct: 0
            }
        ];

        var levelMap = [
            {
                min: 0, max: 3, level: 'Beginner',
                title: 'You are a Beginner!',
                desc: 'No worries — everyone starts somewhere. IndoSlang will guide you from the basics step by step.',
                mascot: 'Images/OWI SPARKLE EYE BIG.png',
                module: 'Module1.aspx', moduleName: 'Module 1', pillId: 'pill1'
            },
            {
                min: 4, max: 6, level: 'Elementary',
                title: 'You are Elementary level!',
                desc: "You already know some Indonesian slang. Let's build on that and fill in the gaps.",
                mascot: 'Images/OWI SPARKLE EYE BIG.png',
                module: 'Module3.aspx', moduleName: 'Module 3', pillId: 'pill2'
            },
            {
                min: 7, max: 9, level: 'Intermediate',
                title: 'You are Intermediate level!',
                desc: 'Nice work! You understand quite a lot already. Time for more contextual slang.',
                mascot: 'Images/OWI SPARKLE EYE BIG.png',
                module: 'Module5.aspx', moduleName: 'Module 5', pillId: 'pill3'
            },
            {
                min: 10, max: 12, level: 'Advanced',
                title: 'You are Advanced level!',
                desc: 'Okay okay, we see you. Jump straight into full conversation practice.',
                mascot: 'Images/OWI SPARKLE EYE BIG.png',
                module: 'Module7.aspx', moduleName: 'Module 7', pillId: 'pill4'
            }
        ];

        var letters = ['A', 'B', 'C', 'D', 'E'];
        var currentQ = 0;
        var score = 0;
        var selectedOption = -1;
        var finalResult = null;

        function buildContext(q) {
            var container = document.getElementById('qContext');
            container.innerHTML = '';
            if (q.contextType === 'none') return;

            if (q.contextType === 'plain') {
                var div = document.createElement('div');
                div.className = 'question-context';
                div.textContent = q.context;
                container.appendChild(div);
            }

            if (q.contextType === 'social') {
                var card = document.createElement('div');
                card.className = 'social-card';
                var label = document.createElement('div');
                label.className = 'social-label';
                label.textContent = q.contextLabel;
                var text = document.createElement('div');
                text.className = 'social-text';
                text.textContent = q.context;
                card.appendChild(label);
                card.appendChild(text);
                container.appendChild(card);
            }

            if (q.contextType === 'chat') {
                var card = document.createElement('div');
                card.className = 'chat-card';
                if (q.contextLabel) {
                    var glabel = document.createElement('div');
                    glabel.className = 'social-label';
                    glabel.textContent = q.contextLabel;
                    card.appendChild(glabel);
                }
                q.context.forEach(function (line) {
                    var row = document.createElement('div');
                    row.className = 'chat-row';
                    var name = document.createElement('div');
                    name.className = 'chat-name';
                    name.textContent = line.name;
                    var bubble = document.createElement('div');
                    bubble.className = 'chat-bubble';
                    bubble.textContent = line.msg;
                    row.appendChild(name);
                    row.appendChild(bubble);
                    card.appendChild(row);
                });
                container.appendChild(card);
            }
        }

        function renderQuestion(index) {
            var q = questions[index];
            selectedOption = -1;
            document.getElementById('btnNext').disabled = true;

            var pct = (index / questions.length) * 100;
            document.getElementById('progressFill').style.width = pct + '%';
            document.getElementById('progressCount').textContent = (index + 1) + ' / ' + questions.length;
            document.getElementById('qNumber').textContent = 'Question ' + (index + 1);

            buildContext(q);
            document.getElementById('qText').textContent = q.question;

            var optionsEl = document.getElementById('qOptions');
            optionsEl.innerHTML = '';

            q.options.forEach(function (optText, i) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'option-btn' + (i === 4 ? ' opt-lost' : '');
                btn.innerHTML = '<span class="option-letter">' + letters[i] + '</span>' + optText;
                btn.onclick = function () {
                    document.querySelectorAll('.option-btn').forEach(function (b) { b.classList.remove('selected'); });
                    btn.classList.add('selected');
                    selectedOption = i;
                    document.getElementById('btnNext').disabled = false;
                };
                optionsEl.appendChild(btn);
            });
        }

        function nextQuestion() {
            if (selectedOption === -1) return;
            if (selectedOption === questions[currentQ].correct) score++;
            currentQ++;
            if (currentQ >= questions.length) {
                showResult();
            } else {
                renderQuestion(currentQ);
            }
        }

        function showResult() {
            document.getElementById('progressFill').style.width = '100%';
            document.getElementById('quizArea').style.display = 'none';
            document.getElementById('quizHeader').style.display = 'none';
            document.getElementById('progressWrap').style.display = 'none';

            finalResult = levelMap[0];
            for (var i = 0; i < levelMap.length; i++) {
                if (score >= levelMap[i].min && score <= levelMap[i].max) {
                    finalResult = levelMap[i];
                    break;
                }
            }

            document.getElementById('resultMascotImg').src = finalResult.mascot;
            document.getElementById('resultCard').style.display = 'block';
            document.getElementById('resultTitle').textContent = finalResult.title;
            document.getElementById('resultScore').textContent = score + '/12';
            document.getElementById('resultLevelBadge').textContent = finalResult.level;
            document.getElementById('resultDesc').textContent = finalResult.desc;
            document.getElementById('startModuleName').textContent = finalResult.moduleName;

            document.querySelectorAll('.level-pill').forEach(function (p) { p.classList.remove('active'); });
            document.getElementById(finalResult.pillId).classList.add('active');
        }

        function submitQuizResult() {
            document.getElementById('<%= hfScore.ClientID %>').value = score;
            document.getElementById('<%= hfLevel.ClientID %>').value = finalResult.level;
            document.getElementById('<%= hfModule.ClientID %>').value = finalResult.module;
            document.getElementById('<%= btnSaveQuiz.ClientID %>').click();
        }

        function retakeQuiz() {
            currentQ = 0; score = 0; selectedOption = -1; finalResult = null;
            document.getElementById('resultCard').style.display = 'none';
            document.getElementById('quizArea').style.display = 'block';
            document.getElementById('quizHeader').style.display = 'block';
            document.getElementById('progressWrap').style.display = 'flex';
            document.querySelectorAll('.level-pill').forEach(function (p) { p.classList.remove('active'); });
            renderQuestion(0);
        }

        renderQuestion(0);
    </script>
</asp:Content>