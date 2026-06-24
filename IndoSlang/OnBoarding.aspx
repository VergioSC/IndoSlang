<%@ Page Title="Welcome to IndoSlang" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OnBoarding.aspx.cs" Inherits="IndoSlang.OnBoarding" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .onboard-wrapper {
            min-height: calc(100vh - 68px);
            background: var(--cream);
            font-family: var(--font-body);
            color: var(--brown);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .onboard-box {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 40px rgba(59,42,26,0.10);
            width: 100%;
            max-width: 780px;
            min-height: 460px;
            padding: 60px 64px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
        }

        .screen { display: none; width: 100%; }
        .screen.active { display: flex; flex-direction: column; align-items: center; justify-content: center; }

        .welcome-title {
            font-family: var(--font-display);
            font-size: 2.4rem;
            color: var(--brown);
            margin-bottom: 16px;
        }

        .welcome-subtitle {
            font-size: 1.05rem;
            color: var(--brown);
            font-weight: 700;
            margin-bottom: 20px;
        }

        .welcome-body {
            font-size: 0.95rem;
            color: var(--brown-mid);
            line-height: 1.9;
            margin-bottom: 40px;
            max-width: 520px;
        }

        .mascot-layout,
        .question-layout {
            display: flex;
            align-items: center;
            gap: 48px;
            text-align: left;
            width: 100%;
        }

        .question-layout {
            align-items: flex-start;
        }

        .mascot-img,
        .question-mascot {
            width: 200px;
            min-width: 200px;
            height: 260px;
            background: var(--cream-mid);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            flex-shrink: 0;
        }

        .mascot-img img,
        .question-mascot img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .mascot-placeholder {
            font-size: 5rem;
        }

        .mascot-text,
        .question-body {
            flex: 1;
        }

        .mascot-text p {
            font-size: 1rem;
            color: var(--brown-mid);
            margin-bottom: 28px;
            line-height: 1.7;
        }

        .mascot-text strong {
            color: var(--brown);
        }

        .question-title {
            font-family: var(--font-display);
            font-size: 1.3rem;
            color: var(--brown);
            margin-bottom: 20px;
            line-height: 1.4;
        }

        .q-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 28px;
        }

        .q-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 16px;
            border: 2px solid var(--cream-mid);
            border-radius: 12px;
            cursor: pointer;
            font-size: 0.92rem;
            color: var(--brown);
            background: var(--cream);
            transition: border-color 0.2s, background 0.2s;
        }

        .q-option:hover {
            border-color: var(--accent);
            background: #fdf4ea;
        }

        .q-option.selected {
            border-color: var(--accent);
            background: #fce9d0;
        }

        .q-option input[type="radio"] {
            accent-color: var(--accent);
            width: 16px;
            height: 16px;
            flex-shrink: 0;
        }

        .btn-onboard {
            background: var(--brown);
            color: #fff;
            border: none;
            padding: 13px 36px;
            border-radius: 40px;
            font-family: var(--font-display);
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-onboard:hover {
            background: var(--brown-mid);
            transform: translateY(-2px);
        }

        .btn-onboard:disabled {
            opacity: 0.4;
            cursor: default;
            transform: none;
        }

        .btn-onboard.accent {
            background: var(--accent);
        }

        .btn-onboard.accent:hover {
            background: var(--accent-light);
        }

        .nav-row {
            display: flex;
            justify-content: flex-end;
            width: 100%;
            margin-top: 8px;
        }

        .popup-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 200;
            align-items: center;
            justify-content: center;
        }

        .popup-overlay.visible {
            display: flex;
        }

        .popup-card {
            background: #fff;
            border-radius: 24px;
            padding: 48px 44px;
            max-width: 480px;
            width: 90%;
            text-align: center;
            box-shadow: 0 12px 48px rgba(0,0,0,0.2);
            animation: popIn 0.3s cubic-bezier(.22,.85,.44,1) both;
        }

        @keyframes popIn {
            from { opacity: 0; transform: scale(0.92); }
            to { opacity: 1; transform: scale(1); }
        }

        .popup-mascot {
            width: 90px;
            height: 90px;
            margin: 0 auto 12px;
        }

        .popup-mascot img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .popup-title {
            font-family: var(--font-display);
            font-size: 1.9rem;
            color: var(--brown);
            margin-bottom: 14px;
        }

        .popup-body {
            font-size: 0.95rem;
            color: var(--brown-mid);
            line-height: 1.7;
            margin-bottom: 28px;
        }

        .btn-popup {
            background: var(--brown);
            color: #fff;
            border: 2px solid var(--cream-mid);
            padding: 13px 28px;
            border-radius: 40px;
            font-family: var(--font-display);
            font-size: 0.95rem;
            cursor: pointer;
            transition: background 0.2s;
            line-height: 1.4;
        }

        .btn-popup:hover {
            background: var(--brown-mid);
        }

        .hidden-server-btn {
            display: none;
        }

        @media (max-width: 720px) {
            .onboard-box {
                padding: 36px 24px;
            }

            .mascot-layout,
            .question-layout {
                flex-direction: column;
                text-align: center;
                gap: 28px;
            }

            .mascot-img,
            .question-mascot {
                width: 170px;
                min-width: 170px;
                height: 220px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!--
        ONBOARDING FLOW:
        - Visitor answers 3 onboarding questions.
        - Answers are stored in hidden fields.
        - btnContinue_Click saves answers into Session.
        - Then redirects to PlacementQuiz.aspx.

        DATABASE NOTE:
        - Current ERD has no OnBoarding table.
        - Do NOT create a new table.
        - Keep onboarding answers in Session for current prototype.
        - Register.aspx / PlacementQuiz.aspx handles actual database-related user flow later.
    -->

    <div class="onboard-wrapper">
        <div class="onboard-box">

            <div class="screen active" id="screen1">
                <h1 class="welcome-title">Welcome to IndoSlang</h1>
                <p class="welcome-subtitle">Before we start &mdash; how does Indonesian slang work?</p>
                <p class="welcome-body">
                    Indonesian slang is all about shortcuts.<br />
                    Indonesians take everyday words and phrases<br />
                    and twist them into something shorter, funkier, and more fun.<br />
                    Some words get squished together.<br />
                    Some get borrowed from English. Some just sound cool.<br />
                    Once you spot the pattern, every new word just clicks.
                </p>
                <button type="button" class="btn-onboard" id="btnNext1">Next! →</button>
            </div>

            <div class="screen" id="screen2">
                <div class="mascot-layout">
                    <div class="mascot-img">
                        <img src="Images/OWI STANDING.png" alt="OWI Mascot" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                        <span class="mascot-placeholder" style="display:none;">🐒</span>
                    </div>

                    <div class="mascot-text">
                        <p><strong>Before we go further, we've got a few quick questions for you.</strong></p>
                        <p>Just 3 questions &mdash; no wrong answers, promise!</p>
                        <button type="button" class="btn-onboard accent" id="btnNext2">Let's Go →</button>
                    </div>
                </div>
            </div>

            <div class="screen" id="screen3">
                <div class="question-layout">
                    <div class="question-mascot">
                        <img src="Images/OWI LOVE.png" alt="OWI Mascot" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                        <span class="mascot-placeholder" style="display:none;">🐒</span>
                    </div>

                    <div class="question-body">
                        <div class="question-title">Why do you want to learn Indonesian slang?</div>

                        <div class="q-options">
                            <label class="q-option"><input type="radio" name="q1" value="Understand friends" /> A. To understand my Indonesian friends better</label>
                            <label class="q-option"><input type="radio" name="q1" value="Social media" /> B. Get memes and social media comments</label>
                            <label class="q-option"><input type="radio" name="q1" value="Travel or living" /> C. Travelling or living in Indonesia</label>
                            <label class="q-option"><input type="radio" name="q1" value="School or project" /> D. School / Project</label>
                            <label class="q-option"><input type="radio" name="q1" value="Gaming" /> E. Gaming with Indonesian players</label>
                            <label class="q-option"><input type="radio" name="q1" value="Curious" /> F. Just curious</label>
                        </div>

                        <div class="nav-row">
                            <button type="button" class="btn-onboard" id="btnQ1" disabled>Next Question →</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="screen" id="screen4">
                <div class="question-layout">
                    <div class="question-mascot">
                        <img src="Images/OWI HI.png" alt="OWI Mascot" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                        <span class="mascot-placeholder" style="display:none;">🐒</span>
                    </div>

                    <div class="question-body">
                        <div class="question-title">How often do you interact with Indonesian content or people?</div>

                        <div class="q-options">
                            <label class="q-option"><input type="radio" name="q2" value="Rarely" /> A. Rarely &mdash; mostly just starting out</label>
                            <label class="q-option"><input type="radio" name="q2" value="Sometimes" /> B. Sometimes &mdash; I follow some Indonesian accounts</label>
                            <label class="q-option"><input type="radio" name="q2" value="Often" /> C. Often &mdash; I chat or watch Indonesian content regularly</label>
                            <label class="q-option"><input type="radio" name="q2" value="Daily" /> D. Daily &mdash; it's part of my everyday life</label>
                        </div>

                        <div class="nav-row">
                            <button type="button" class="btn-onboard" id="btnQ2" disabled>Next Question →</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="screen" id="screen5">
                <div class="question-layout">
                    <div class="question-mascot">
                        <img src="Images/OWI SHOCKED.png" alt="OWI Mascot" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                        <span class="mascot-placeholder" style="display:none;">🐒</span>
                    </div>

                    <div class="question-body">
                        <div class="question-title">How much Indonesian slang do you already know?</div>

                        <div class="q-options">
                            <label class="q-option"><input type="radio" name="q3" value="Zero" /> A. Zero &mdash; never heard any Indonesian slang</label>
                            <label class="q-option"><input type="radio" name="q3" value="Little" /> B. A little &mdash; maybe a few words</label>
                            <label class="q-option"><input type="radio" name="q3" value="Some" /> C. Some &mdash; but I don't always get the context</label>
                            <label class="q-option"><input type="radio" name="q3" value="Quite a lot" /> D. Quite a lot &mdash; I use it sometimes</label>
                        </div>

                        <div class="nav-row">
                            <button type="button" class="btn-onboard" id="btnQ3" disabled>Next! →</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="popup-overlay" id="popupOverlay">
        <div class="popup-card">
            <div class="popup-mascot">
                <img id="popupMascotImg" src="Images/OWI SPARKLE EYE BIG.png" alt="OWI" />
            </div>
            <div class="popup-title" id="popupTitle">Got It!</div>
            <p class="popup-body" id="popupBody">From zero to local.</p>

            <button type="button" class="btn-popup" id="btnPopupGo">
                Next stop:<br />the placement quiz!
            </button>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        var q1Answer = '', q2Answer = '', q3Answer = '';

        function showScreen(n) {
            for (var i = 1; i <= 5; i++) {
                var el = document.getElementById('screen' + i);
                if (el) el.classList.remove('active');
            }
            var target = document.getElementById('screen' + n);
            if (target) target.classList.add('active');
        }

        window.addEventListener('load', function () {

            document.getElementById('btnNext1').addEventListener('click', function () { showScreen(2); });
            document.getElementById('btnNext2').addEventListener('click', function () { showScreen(3); });
            document.getElementById('btnQ1').addEventListener('click', function () { showScreen(4); });
            document.getElementById('btnQ2').addEventListener('click', function () { showScreen(5); });

            document.getElementById('btnQ3').addEventListener('click', function () {
                var popups = {
                    'Zero':        { title: 'Got It!',      body: 'From zero to local. IndoSlang will help you start from the basics.' },
                    'Little':      { title: 'Nice pick!',   body: 'You already have a small head start. The quiz will place you properly.' },
                    'Some':        { title: 'Locked in!',   body: 'That\'s a great stage to learn. Let\'s check your level next.' },
                    'Quite a lot': { title: 'Cool choice!', body: 'Okay, big claim. The placement quiz will test how much you really know.' }
                };
                var p = popups[q3Answer] || popups['Zero'];
                document.getElementById('popupTitle').textContent = p.title;
                document.getElementById('popupBody').textContent = p.body;
                document.getElementById('popupOverlay').classList.add('visible');
            });

            document.getElementById('btnPopupGo').addEventListener('click', function () {
                window.location.href = 'PlacementQuiz.aspx?goal=' + encodeURIComponent(q1Answer)
                    + '&freq=' + encodeURIComponent(q2Answer)
                    + '&know=' + encodeURIComponent(q3Answer);
            });

            var radios = document.querySelectorAll('input[type="radio"]');
            for (var i = 0; i < radios.length; i++) {
                radios[i].addEventListener('change', function () {
                    var name = this.name;
                    var group = document.querySelectorAll('input[name="' + name + '"]');
                    for (var j = 0; j < group.length; j++) {
                        if (group[j].parentNode) group[j].parentNode.classList.remove('selected');
                    }
                    if (this.parentNode) this.parentNode.classList.add('selected');

                    if (name === 'q1') { q1Answer = this.value; document.getElementById('btnQ1').disabled = false; }
                    if (name === 'q2') { q2Answer = this.value; document.getElementById('btnQ2').disabled = false; }
                    if (name === 'q3') { q3Answer = this.value; document.getElementById('btnQ3').disabled = false; }
                });
            }
        });
    </script>
</asp:Content>