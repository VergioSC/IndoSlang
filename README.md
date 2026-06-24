[README.md](https://github.com/user-attachments/files/29294226/README.md)
# IndoSlang 🇮🇩

A web-based e-learning platform for learning Indonesian Gen Z slang, built with ASP.NET Web Forms, C#, and SQL Server.

> **CT050-3-2-WAPP | Web Applications | Group 11 | Asia Pacific University (APU)**

---

## About

**IndoSlang** combines "Indo" (Indonesia) and "Slang" (informal everyday language). It is a structured yet playful digital learning platform that bridges the gap between formal Bahasa Indonesia and the informal language used by Indonesian young adults today.

The platform mascot is **Owi**, based on the Javan Gibbon (Owa Jawa) — a creature native to Indonesia, designed by the APU Indonesian Student Society (AUISS).

---

## Features

| Feature | Description |
|---|---|
| Placement Quiz | Assigns users to the correct starting level based on their existing knowledge |
| Learning Modules | 8 levelled modules across Beginner, Elementary, Intermediate, and Advanced |
| Progress Tracking | Records completed modules and quiz scores |
| Slang Dictionary | Fully searchable dictionary with community suggestion and admin approval flow |
| Buddy System | Members can apply to become Buddies (fluent speakers); others can book live sessions with them |
| Community Chat | Registered members and buddies can interact and discuss Indonesian slang |
| Admin Dashboard | Full management of users, content, session reports, and buddy approvals |
| OTP Verification | Email-based OTP for account security |

---

## Tech Stack

- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5
- **Backend:** ASP.NET Web Forms (.NET Framework 4.7.2), C#
- **Database:** SQL Server (LocalDB) — schema in `Database_Setup.sql`
- **IDE:** Visual Studio

---

## Getting Started

### Prerequisites

- Visual Studio 2022
- SQL Server / SQL Server Express (LocalDB)
- .NET Framework 4.7.2

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/VergioSC/IndoSlang.git
   ```

2. Open `IndoSlang.slnx` in Visual Studio.

3. Set up the database:
   - Open SQL Server Management Studio (SSMS)
   - Run `Database_Setup.sql` to create and seed the database

4. Update the connection string in `Web.config` if needed to match your local SQL Server instance.

5. Press **F5** or click **Start** to run the project.

---

## User Roles

The system supports four roles:

| Role | Description |
|---|---|
| **Visitor** | Can browse the homepage and access a preview of the slang dictionary |
| **Member** | Full access to modules, dictionary, community chat, and buddy booking |
| **Buddy** | Fluent Indonesian speaker; hosts live sessions and earns from bookings |
| **Admin** | Manages all users, content, buddy approvals, and session reports |

### Demo Accounts

> ⚠️ These credentials are for **local/demo use only**. Do not use in a production environment.

| Role | Email | Password |
|---|---|---|
| Admin | `admin@indoslang.com` | `admin123` |
| Buddy | `rachel@gmail.com` | `test123` |
| Member | `ayamgoreng@gmail.com` | `ayambakar` |

---

## Project Structure

```
IndoSlang/
├── IndoSlang/          # Main web application
│   ├── *.aspx          # Web pages (Login, Dashboard, Modules, etc.)
│   ├── *.aspx.cs       # Code-behind files (C#)
│   ├── DBHelper.cs     # Database helper class
│   ├── EmailHelper.cs  # OTP email helper
│   ├── Content/        # CSS stylesheets (Bootstrap + custom)
│   ├── Scripts/        # JavaScript files
│   └── Images/         # Owi mascot and other assets
├── Database_Setup.sql  # Database schema and seed data
└── IndoSlang.slnx      # Visual Studio solution file
```

---

## Team

| Name | TP Number |
|---|---|
| Erica Alexandra Wang | TP079141 |
| Evelyn Angelica Lie | TP080767 |
| Selina | TP083876 |
| Vergio Stevencen | TP079623 |

**Lecturer:** Dr. Lai Ngan Kuen  
**Module:** CT050-3-2 Web Applications  
**Institution:** Asia Pacific University (APU), Kuala Lumpur
