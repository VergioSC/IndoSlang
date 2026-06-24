<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="IndoSlang.HomePage" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>

        /* HERO SECTION */

        .hero-section {
            background: var(--cream);
            padding: 72px 32px 80px;
            position: relative;
            overflow: hidden;
        }

        .hero-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Floating monkey images on left and right sides */
        .monkey-float {
            position: absolute;
            width: 350px;
            height: auto;
            animation: floatBob 3.5s ease-in-out infinite;
            user-select: none;
            pointer-events: none;
        }
        .monkey-float:nth-child(1) { top: 60px;    left: 10px;   animation-delay: 0s;   }
        .monkey-float:nth-child(2) { top: 80px;    right: 10px;  animation-delay: 0.8s; }
        .monkey-float:nth-child(3) { bottom: 70px; left: 40px;   animation-delay: 1.4s; }
        .monkey-float:nth-child(4) { bottom: 50px; right: 40px;  animation-delay: 2.0s; }

        @keyframes floatBob {
            0%, 100% { transform: translateY(0);     }
            50%       { transform: translateY(-12px); }
        }

        /* Main hero card - starts hidden, JS adds .is-visible to trigger slide-up */
        .hero-card {
            background: var(--cream-mid);
            border-radius: 28px;
            padding: 56px 80px;
            text-align: center;
            max-width: 680px;
            width: 100%;
            box-shadow: 0 20px 40px var(--shadow);
            position: relative;
            z-index: 1;
            opacity: 0;
            transform: translateY(32px);
            transition: transform 0.6s cubic-bezier(.22,.85,.44,1),
                        box-shadow 0.2s,
                        opacity 0.6s;
        }

        .hero-card.is-visible {
            opacity: 1;
            transform: translateY(0);
        }

        .hero-card.is-visible:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px var(--shadow);
        }

        .hero-title {
            font-family: var(--font-display);
            font-size: 2.8rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 4px;
            line-height: 1.15;
        }

        .hero-title-underline {
            display: block;
            width: 80%;
            height: 3px;
            background: var(--brown);
            margin: 8px auto 16px;
            border-radius: 2px;
        }

        .hero-subtitle {
            font-size: 1rem;
            color: var(--brown-mid);
            margin-bottom: 28px;
        }

        .hero-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 36px;
        }

        /* Stats strip at the bottom of the hero card */
        .hero-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0;
            border-top: 2px solid rgba(59,42,26,0.12);
            padding-top: 24px;
            width: 100%;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2px;
            border-right: 2px solid rgba(59,42,26,0.12);
            padding: 0 16px;
        }

        .stat-item:last-child { border-right: none; }

        .stat-number {
            font-family: var(--font-display);
            font-size: 1.55rem;
            font-weight: 700;
            color: var(--brown);
        }

        .stat-label {
            font-size: 0.8rem;
            color: var(--brown-mid);
            font-weight: 600;
            text-align: center;
        }


        /* SHARED SECTION STYLES + BUTTONS */

        .section {
            padding: 80px 32px;
        }

        .section-inner {
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-label {
            font-size: 1.1rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 8px;
        }

        .section-title {
            font-family: var(--font-display);
            font-size: 2.1rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 48px;
        }

        /* Primary button - dark brown fill */
        .btn-primary {
            display: inline-block;
            background: var(--brown);
            color: var(--white);
            font-family: var(--font-body);
            font-weight: 700;
            font-size: 0.95rem;
            padding: 13px 26px;
            border-radius: 12px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-primary:hover { background: var(--brown-mid); transform: translateY(-2px); }

        /* Secondary button - outlined style */
        .btn-secondary {
            display: inline-block;
            background: var(--white);
            color: var(--brown);
            font-family: var(--font-body);
            font-weight: 700;
            font-size: 0.95rem;
            padding: 13px 26px;
            border-radius: 12px;
            text-decoration: none;
            border: 2px solid var(--brown);
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-secondary:hover { background: var(--cream); transform: translateY(-2px); }

        /* Large button variant used for the hero CTA */
        .btn-large {
            font-size: 1.8rem;
            padding: 18px 48px;
            border-radius: 16px;
            letter-spacing: 0.5px;
        }


        /* SECTION HOW IT WORKS STEPS */

        .steps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 24px;
        }

        .step-card {
            background: var(--white);
            border-radius: 20px;
            padding: 32px 28px;
            box-shadow: 0 4px 24px var(--shadow);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .step-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 48px var(--shadow);
        }

        .step-num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid var(--cream-mid);
            font-family: var(--font-display);
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--brown-mid);
            margin-bottom: 14px;
        }

        .step-title {
            font-family: var(--font-display);
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 8px;
        }

        .step-desc {
            font-size: 0.9rem;
            color: var(--brown-mid);
            line-height: 1.6;
        }


        /* SLANG OF THE DAY */

        .sotd-section {
            background: var(--cream-mid);
            padding: 72px 32px;
            position: relative;  
        }

        .sotd-card {
            background: var(--white);
            border-radius: 20px;
            padding: 32px 36px;
            max-width: 680px;
            box-shadow: 0 4px 24px var(--shadow);
            display: flex;
            align-items: flex-start;
            gap: 20px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .sotd-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 48px var(--shadow);
        }

        .sotd-emoji { font-size: 2.8rem; flex-shrink: 0; }

        .sotd-word {
            font-family: var(--font-display);
            font-size: 2rem;
            font-weight: 700;
            color: var(--brown);
        }

        .sotd-tag {
            display: inline-block;
            background: var(--cream-mid);
            color: var(--brown-mid);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            margin-left: 8px;
            vertical-align: middle;
        }

        .sotd-meaning {
            font-weight: 700;
            color: var(--brown-mid);
            margin: 4px 0 2px;
            font-size: 0.95rem;
        }

        .sotd-example {
            font-size: 0.9rem;
            color: var(--brown-mid);
            font-style: italic;
        }
        .sotd-owi {
            position: absolute;
            right: calc(50% - 580px);
            bottom: 0;
            width: 370px;
            height: auto;
            pointer-events: none;
            animation: floatBob 3.5s ease-in-out infinite;
            animation-delay: 0.5s;
        }

        /* FEATURES GRID */

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }

        .feature-card {
            background: var(--white);
            border-radius: 18px;
            padding: 28px 24px;
            box-shadow: 0 3px 18px var(--shadow);
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 48px var(--shadow);
        }

        .feature-icon  { font-size: 1.8rem; }

        .feature-title {
            font-family: var(--font-display);
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brown);
        }

        .feature-desc {
            font-size: 0.88rem;
            color: var(--brown-mid);
            line-height: 1.6;
        }


        /* CTA BANNER + RESPONSIVE */

        .cta-section {
            background: var(--brown);
            padding: 40px 32px 20px;
            text-align: center;
        }

        .cta-section h2 {
            font-family: var(--font-display);
            font-size: 2.4rem;
            color: var(--white);
            margin-bottom: 12px;
        }

        .cta-section p {
            color: var(--cream-mid);
            font-size: 1rem;
            opacity: 0.85;
            margin-bottom: 0;
        }

        /* Mobile responsiveness */
        @media (max-width: 640px) {
            .hero-card       { padding: 36px 24px; }
            .hero-title      { font-size: 2rem; }
            .monkey-float    { display: none; }
            .hero-stats      { grid-template-columns: 1fr; gap: 16px; }
            .stat-item       { border-right: none; border-bottom: 2px solid rgba(59,42,26,0.12); padding-bottom: 12px; }
            .stat-item:last-child { border-bottom: none; }
        }

    </style>
</asp:Content>


<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!--  HERO  -->
    <section class="hero-section">

        <!-- Decorative floating monkeys on the sides -->
        <img src="Images/OWI LOVE.png"               class="monkey-float" alt="" />
        <img src="Images/OWI MAD.png"                class="monkey-float" alt="" />
        <img src="Images/OWI SHOCKED.png"            class="monkey-float" alt="" />
        <img src="Images/OWI SPARKLE EYE SMALL.png"  class="monkey-float" alt="" />

        <div class="hero-inner">
            <div class="hero-card">
                <h1 class="hero-title">Speak like an Indonesian</h1>
                <span class="hero-title-underline"></span>
                <p class="hero-subtitle">Fun, informal, and actually used by Indonesians</p>

                <div class="hero-buttons">
                    <a href="OnBoarding.aspx" class="btn-primary btn-large">Let's get started!</a>
                </div>

                <!-- Quick stats strip -->
                <div class="hero-stats">
                    <div class="stat-item">
                        <span class="stat-number"><%= SlangCount %></span>
                        <span class="stat-label">Slang Words</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">8 Modules</span>
                        <span class="stat-label">Beginner → Advanced</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">Live Buddies</span>
                        <span class="stat-label">Real speaking sessions</span>
                    </div>
                </div>
            </div>
        </div>
    </section>


    <!--  HOW IT WORKS -->
    <section class="section">
        <div class="section-inner">
            <p class="section-label">How it works</p>
            <h2 class="section-title">Learn slang in 3 easy steps</h2>

            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-num">01</div>
                    <div class="step-title">Take the quiz</div>
                    <p class="step-desc">Our placement quiz figures out exactly where you should start.</p>
                </div>
                <div class="step-card">
                    <div class="step-num">02</div>
                    <div class="step-title">Learn via modules</div>
                    <p class="step-desc">Vocab flashcards, quizzes, real chat scenarios &mdash; leveled from Beginner to Advanced.</p>
                </div>
                <div class="step-card">
                    <div class="step-num">03</div>
                    <div class="step-title">Book a buddy</div>
                    <p class="step-desc">Live session with a fluent Indonesian speaker to practice real conversations.</p>
                </div>
            </div>
        </div>
    </section>


    <!--  SLANG OF THE DAY  -->
    <!-- Word and details are loaded from the database in HomePage.aspx.cs -->
    <section class="sotd-section">
        <div class="section-inner">
            <p class="section-label">Slang of the day</p>
            <h2 class="section-title">Today's word 🔥</h2>

            <div class="sotd-card">
                <span class="sotd-emoji">💬</span>
                <div>
                    <div>
                        <span class="sotd-word"><span id="sotdWord" runat="server"></span></span>
                        <span class="sotd-tag"><span id="sotdPos" runat="server"></span></span>
                    </div>
                    <p class="sotd-meaning"><span id="sotdMeaning" runat="server"></span></p>
                    <p class="sotd-example"><span id="sotdExample" runat="server"></span></p>
                    <a href="SlangDictionary.aspx" class="btn-secondary"
                       style="display:inline-block; margin-top:16px; font-size:0.82rem; padding:8px 16px;
                              background:var(--cream-mid); border-color:var(--brown-mid); color:var(--brown);">
                        See more &rarr;
                    </a>
                </div>
            </div>
        </div>

        <!-- Floating Owi Standing -->
        <img src="Images/OWI STANDING.png" class="sotd-owi" alt="" />
    </section>


    <!--  WHY INDOSLANG FEATURES  -->
    <section class="section">
        <div class="section-inner">
            <p class="section-label">Why IndoSlang?</p>
            <h2 class="section-title">Everything you need to fit in</h2>

            <div class="features-grid">
                <div class="feature-card">
                    <span class="feature-icon">📖</span>
                    <div class="feature-title"><%= SlangCount %>+ Slang Dictionary</div>
                    <p class="feature-desc">Browse the full Gen Z Indonesian slang dictionary with meanings, examples, and usage tips.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-icon">🎯</span>
                    <div class="feature-title">Level-Based Modules</div>
                    <p class="feature-desc">Eight progressive modules from absolute beginner to advanced slang mastery.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-icon">📊</span>
                    <div class="feature-title">Progress Tracking</div>
                    <p class="feature-desc">Track your quiz scores and completed modules so you always know where you stand.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-icon">💬</span>
                    <div class="feature-title">Community Chat</div>
                    <p class="feature-desc">Chat with other learners and buddies in real time, just like a real Indonesian group chat.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-icon">🤝</span>
                    <div class="feature-title">Live Buddy Sessions</div>
                    <p class="feature-desc">Book 1-on-1 speaking sessions with verified fluent Indonesian speakers.</p>
                </div>
                <div class="feature-card">
                    <span class="feature-icon">✨</span>
                    <div class="feature-title">Suggest Slang</div>
                    <p class="feature-desc">Know a slang word we don't have? Submit it for admin review and help grow the platform.</p>
                </div>
            </div>
        </div>
    </section>


    <!--  CTA BANNER  -->
    <section class="cta-section">
        <h2>
            Ready to sound like a local?
            <img src="Images/OWI SPARKLE EYE BIG.png" alt=""
                 style="width:58px; height:auto; vertical-align:middle; margin-left:-5px;" />
        </h2>
        <p>Join thousands of learners mastering Indonesian Gen Z slang.</p>
    </section>

</asp:Content>


<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // Trigger hero card slide-up animation on page load
            var heroCard = document.querySelector('.hero-card');
            setTimeout(function () {
                heroCard.classList.add('is-visible');
            }, 50);

            // Fade-in step and feature cards when they scroll into view
            var cards = document.querySelectorAll('.step-card, .feature-card');
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.15 });

            // Set initial hidden state for cards before they appear
            cards.forEach(function (card, i) {
                card.style.opacity = '0';
                card.style.transform = 'translateY(24px)';
                card.style.transition = 'opacity 0.5s ease ' + (i * 0.08) + 's, transform 0.5s ease ' + (i * 0.08) + 's, box-shadow 0.2s';
                observer.observe(card);
            });

        });
    </script>
</asp:Content>