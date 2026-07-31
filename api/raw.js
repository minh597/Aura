import fs from "fs";
import path from "path";

export default function handler(req, res) {
    res.setHeader("Content-Type", "application/json");
    res.send(JSON.stringify(req.headers, null, 2));
}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Forbidden</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #0f172a;
            color: white;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .box {
            text-align: center;
            padding: 40px;
            background: #1e293b;
            border-radius: 12px;
        }

        h1 {
            font-size: 64px;
            color: #ef4444;
            margin-bottom: 10px;
        }

        h2 {
            margin-bottom: 15px;
        }

        p {
            color: #cbd5e1;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>403</h1>
        <h2>Access Denied</h2>
        <p>You are not allowed to access this resource from here.</p>
    </div>
</body>
</html>
        `);
    }

    const text = fs.readFileSync(
        path.join(process.cwd(), "Aura.lua"),
        "utf8"
    );

    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.setHeader("Cache-Control", "no-store");
    res.send(text);
}
