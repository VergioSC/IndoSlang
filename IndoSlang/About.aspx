<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="IndoSlang.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>

        /* HERO */

        .about-hero {
            background: var(--cream);
            padding: 80px 32px;
            text-align: center;
            position: relative;
            overflow: hidden;
            min-height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .about-hero-card {
            background: var(--cream-mid);
            border-radius: 28px;
            padding: 52px 72px;
            max-width: 640px;
            position: relative;
            z-index: 1;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .about-hero-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 40px 60px rgba(0,0,0,0.25);
        }

        .about-hero-card h1 {
            font-family: var(--font-display);
            font-size: 3.2rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 14px;
            line-height: 1.1;
        }

        .about-hero-card p {
            font-size: 1.05rem;
            color: var(--brown-mid);
            line-height: 1.7;
        }

        /* Floating Owis centered vertically on each side */
        .about-owi-wrap {
            position: absolute;
            top: 0; bottom: 0;
            display: flex;
            align-items: center;
            pointer-events: none;
        }
        .about-owi-wrap.left  { left: 4%; }
        .about-owi-wrap.right { right: 4%; }

        .about-owi-wrap img {
            width: clamp(220px, 25vw, 400px);
            height: auto;
            animation: floatBob 3.5s ease-in-out infinite;
            filter: drop-shadow(0 12px 24px rgba(0,0,0,0.3));
        }
        .about-owi-wrap.right img { animation-delay: 0.8s; }

        @keyframes floatBob {
            0%, 100% { transform: translateY(0);     }
            50%       { transform: translateY(-14px); }
        }


        /* SHARED */
 
        .about-section         { padding: 50px 32px; background: var(--cream); }
        .about-section.alt     { background: var(--cream-mid); }
 
        .about-inner {
            max-width: 1100px;
            margin: 0 auto;
        }
 
        .section-label {
            font-size: 1.1rem;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 8px; 
        }
 
        .section-title {
            font-family: var(--font-display);
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 48px;
        }
 
 
        /* STATS STRIP */
 
        .stats-strip {
            background: var(--cream-mid);
            padding: 48px 32px;
        }
 
        .stats-inner {
            max-width: 1100px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
        }
 
        .stat-block {
            text-align: center;
            padding: 20px;
            border-right: 2px solid rgba(59,42,26,0.12);
        }
        .stat-block:last-child { border-right: none; }
 
        .stat-block .num {
            font-family: var(--font-display);
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--brown);
            display: block;
        }
 
        .stat-block .lbl {
            font-size: 0.85rem;
            color: var(--brown-mid);
            opacity: 0.75;
            margin-top: 4px;
        }
 
 
        /* MISSION */
 
        .mission-section {
            background: var(--cream);
            padding: 50px 32px;
        }
 
        .mission-inner {
            max-width: 1100px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 64px;
            align-items: center;
        }
 
        .mission-text-block .section-title { margin-bottom: 20px; }
 
        .mission-body {
            font-size: 1rem;
            color: var(--brown-mid);
            line-height: 1.85;
        }
 
        .mission-visual {
            display: flex;
            justify-content: center;
            align-items: center;
        }
 
        .mission-visual img {
            width: clamp(200px, 22vw, 360px);
            height: auto;
            animation: floatBob 3.5s ease-in-out infinite;
            filter: drop-shadow(0 16px 32px rgba(59,42,26,0.18));
        }
 
 
        /* OFFER GRID */
 
        .offer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }
 
        .offer-card {
            background: var(--white);
            border-radius: 18px;
            padding: 28px 24px;
            box-shadow: 0 3px 18px var(--shadow);
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
 
        .offer-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 48px var(--shadow);
        }
 
        .offer-icon  { font-size: 1.8rem; }
 
        .offer-title {
            font-family: var(--font-display);
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brown);
        }
 
        .offer-desc {
            font-size: 0.88rem;
            color: var(--brown-mid);
            line-height: 1.6;
        }
 
 
        /* FAQ */
 
        .faq-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-width: 800px;
        }
 
        .faq-item {
            background: var(--white);
            border-radius: 16px;
            box-shadow: 0 3px 16px var(--shadow);
            overflow: hidden;
        }
 
        .faq-question {
            width: 100%;
            background: none;
            border: none;
            padding: 20px 24px;
            text-align: left;
            font-family: var(--font-display);
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--brown);
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.2s;
        }
 
        .faq-question:hover { background: var(--cream); }
 
        .faq-arrow {
            font-size: 0.85rem;
            color: var(--accent);
            transition: transform 0.3s;
            flex-shrink: 0;
        }
        .faq-arrow.open { transform: rotate(180deg); }
 
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.35s ease;
            font-size: 0.95rem;
            color: var(--brown-mid);
            line-height: 1.7;
            padding: 0 24px;
        }
        .faq-answer.open {
            max-height: 300px;
            padding-bottom: 20px;
        }
 
 
        /* TEAM */
 
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 24px;
        }
 
        .team-card {
            background: var(--white);
            border-radius: 20px;
            padding: 32px 20px;
            text-align: center;
            box-shadow: 0 4px 24px var(--shadow);
            transition: transform 0.2s, box-shadow 0.2s;
        }
 
        .team-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 48px var(--shadow);
        }
 
        .team-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--cream-mid);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto 16px;
            box-shadow: 0 4px 16px var(--shadow);
        }
 
        .team-name {
            font-family: var(--font-display);
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brown);
            margin-bottom: 4px;
        }
 
        .team-tp {
            font-size: 0.78rem;
            color: var(--accent);
            font-weight: 700;
            letter-spacing: 0.05em;
        }
 
        .team-role {
            font-size: 0.82rem;
            color: var(--brown-mid);
            margin-top: 8px;
            line-height: 1.55;
        }
 
 
        /* CTA */
 
        .about-cta {
            background: var(--brown);
            padding: 50px 32px;
            text-align: center;
        }

        .about-cta h2 {
            font-family: var(--font-display);
            font-size: 2.4rem;
            color: var(--white);
            margin-bottom: 12px;
        }

        .about-cta p {
            color: var(--cream-mid);
            opacity: 0.8;
            font-size: 1rem;
            margin-bottom: 28px;
        }

        .btn-primary {
            display: inline-block;
            background: var(--accent);
            color: var(--white);
            font-family: var(--font-body);
            font-weight: 700;
            font-size: 1rem;
            padding: 14px 36px;
            border-radius: 14px;
            text-decoration: none;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-primary:hover { background: var(--accent-light); transform: translateY(-2px); }
 
 
        /* RESPONSIVE */
 
        @media (max-width: 768px) {
            .mission-inner           { grid-template-columns: 1fr; gap: 32px; }
            .mission-visual          { display: none; }
            .stats-inner             { grid-template-columns: repeat(2, 1fr); }
            .stat-block:nth-child(2) { border-right: none; }
        }
 
        @media (max-width: 640px) {
            .about-hero-card    { padding: 36px 24px; }
            .about-hero-card h1 { font-size: 2rem; }
            .about-owi-wrap     { display: none; }
        }

    </style>
</asp:Content>


<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HERO -->
    <section class="about-hero">
        <div class="about-owi-wrap left">
            <img src="Images/OWI LOVE.png" alt="" />
        </div>
        <div class="about-owi-wrap right">
            <img src="Images/OWI MAD.png" alt="" />
        </div>

        <div class="about-hero-card">
            <h1>About IndoSlang</h1>
            <p>Making Indonesian Gen Z slang accessible, fun and entertaining to learn for everyone.</p>
        </div>
    </section>


    <!-- STATS STRIP -->
    <div class="stats-strip">
        <div class="stats-inner">
            <div class="stat-block">
                <span class="num"><%= SlangCount %></span>
                <span class="lbl">Slang Words</span>
            </div>
            <div class="stat-block">
                <span class="num">8</span>
                <span class="lbl">Learning Modules</span>
            </div>
            <div class="stat-block">
                <span class="num">4</span>
                <span class="lbl">Difficulty Levels</span>
            </div>
            <div class="stat-block">
                <span class="num">Live</span>
                <span class="lbl">Buddy Sessions</span>
            </div>
        </div>
    </div>


    <!-- MISSION - two column with Owi visual -->
    <section class="about-section mission-section">
        <div class="mission-inner">
            <div class="mission-text-block">
                <p class="section-label">Our Mission</p>
                <h2 class="section-title">Why we built this</h2>
                <p class="mission-body">
                    IndoSlang's mission is to make Indonesian Gen Z slang accessible, fun and entertaining
                    to learn for everyone wanting to know about Indonesian Slang. We aim to bridge the language
                    gap between formal Bahasa Indonesia and the informal language of today's Indonesian young
                    adults &mdash; through a structured yet playful digital learning platform.
                </p>
                <br />
                <p class="mission-body">
                    Through interactive modules, community engagement, and live buddy sessions, IndoSlang
                    allows learners to communicate more naturally, confidently, and authentically in Indonesian.
                </p>
            </div>
            <div class="mission-visual">
                <img src="Images/OWI HI.png" alt="" />
            </div>
        </div>
    </section>


    <!-- WHAT WE OFFER -->
    <section class="about-section alt">
        <div class="about-inner">
            <p class="section-label">What we offer</p>
            <h2 class="section-title">Everything in one place</h2>

            <div class="offer-grid">
                <div class="offer-card">
                    <span class="offer-icon">🎯</span>
                    <div class="offer-title">Level-Based Modules</div>
                    <p class="offer-desc">8 modules from Beginner to Advanced. Learn progressively at your own pace.</p>
                </div>
                <div class="offer-card">
                    <span class="offer-icon">🤝</span>
                    <div class="offer-title">Live Buddy Sessions</div>
                    <p class="offer-desc">Practice real conversation with verified fluent Indonesian speakers.</p>
                </div>
                <div class="offer-card">
                    <span class="offer-icon">📖</span>
                    <div class="offer-title">Slang Dictionary</div>
                    <p class="offer-desc"><%= SlangCount %>+ slang words with meanings, origins, and real example sentences.</p>
                </div>
                <div class="offer-card">
                    <span class="offer-icon">💬</span>
                    <div class="offer-title">Community Chat</div>
                    <p class="offer-desc">Chat with other learners and buddies in real time.</p>
                </div>
                <div class="offer-card">
                    <span class="offer-icon">📊</span>
                    <div class="offer-title">Progress Tracking</div>
                    <p class="offer-desc">Track your quiz scores and module completions to stay motivated.</p>
                </div>
                <div class="offer-card">
                    <span class="offer-icon">✨</span>
                    <div class="offer-title">Suggest Slang</div>
                    <p class="offer-desc">Submit new slang words for admin review and help grow the platform.</p>
                </div>
            </div>
        </div>
    </section>


    <!-- FAQ -->
    <section class="about-section">
        <div class="about-inner">
            <p class="section-label">FAQ</p>
            <h2 class="section-title">Common questions</h2>

            <div class="faq-list">
                <div class="faq-item">
                    <button class="faq-question" type="button">
                        Are the learning modules free? <span class="faq-arrow">▼</span>
                    </button>
                    <div class="faq-answer">
                        Yes! All learning modules and the slang dictionary are completely free. Buddy live sessions are paid &mdash; 95% goes directly to the buddy.
                    </div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" type="button">
                        How do I become a Buddy? <span class="faq-arrow">▼</span>
                    </button>
                    <div class="faq-answer">
                        Register as a member first, then submit a Buddy application from your dashboard. Admin will review and approve it.
                    </div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" type="button">
                        What level should I start at? <span class="faq-arrow">▼</span>
                    </button>
                    <div class="faq-answer">
                        Take our placement quiz &mdash; it will automatically assign you to the right starting level based on your score.
                    </div>
                </div>
                <div class="faq-item">
                    <button class="faq-question" type="button">
                        Is IndoSlang available on mobile? <span class="faq-arrow">▼</span>
                    </button>
                    <div class="faq-answer">
                        IndoSlang is web-based only. It works on any modern browser on both desktop and mobile.
                    </div>
                </div>
            </div>
        </div>
    </section>


    <!-- TEAM -->
    <section class="about-section alt">
        <div class="about-inner">
            <p class="section-label">The Team</p>
            <h2 class="section-title">Built by Group 11</h2>

            <div class="team-grid">
                <div class="team-card">
                    <div class="team-avatar">🦋</div>
                    <div class="team-name">Erica Alexandra Wang</div>
                    <div class="team-tp">TP079141</div>
                </div>
                <div class="team-card">
                    <div class="team-avatar">🐧</div>
                    <div class="team-name">Evelyn Angelica Lie</div>
                    <div class="team-tp">TP080767</div>
                </div>
                <div class="team-card">
                    <div class="team-avatar">🐼</div>
                    <div class="team-name">Selina</div>
                    <div class="team-tp">TP083876</div>
                </div>
                <div class="team-card">
                    <div class="team-avatar">🐟</div>
                    <div class="team-name">Vergio Stevencen</div>
                    <div class="team-tp">TP079623</div>
                </div>
            </div>
        </div>
    </section>


    <!-- CTA -->
    <section class="about-cta">
        <h2>Ready to sound like a local? <img src="Images/OWI SPARKLE EYE BIG.png" alt=""
     style="width:58px; height:auto; vertical-align:middle; margin-left:-5px;" /></h2>
        <p>Join learners mastering Indonesian Gen Z slang today.</p>
        <a href="OnBoarding.aspx" class="btn-primary">Get started for free</a>
    </section>

</asp:Content>


<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // FAQ accordion
            document.querySelectorAll('.faq-question').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    var answer = btn.nextElementSibling;
                    var arrow = btn.querySelector('.faq-arrow');
                    var isOpen = answer.classList.contains('open');

                    document.querySelectorAll('.faq-answer').forEach(function (a) { a.classList.remove('open'); });
                    document.querySelectorAll('.faq-arrow').forEach(function (a) { a.classList.remove('open'); });

                    if (!isOpen) {
                        answer.classList.add('open');
                        arrow.classList.add('open');
                    }
                });
            });

            // Scroll fade-in for cards
            var cards = document.querySelectorAll('.offer-card, .team-card');
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.15 });

            cards.forEach(function (card, i) {
                card.style.opacity = '0';
                card.style.transform = 'translateY(24px)';
                card.style.transition = 'opacity 0.5s ease ' + (i * 0.08) + 's, transform 0.5s ease ' + (i * 0.08) + 's, box-shadow 0.2s';
                observer.observe(card);
            });

        });
    </script>
</asp:Content>