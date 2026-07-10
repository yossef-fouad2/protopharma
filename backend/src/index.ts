import express from "express";
import authRouter from "./routes/auth.js";


const app = express();

// app.use  whenever to use routing or middleware
app.use(express.json());
app.use("/auth", authRouter)

app.get("/", (req, res) => {
    res.send("Welcom to protopharma system!");
})

app.listen(8000, () => {
    console.log('server is running on port 8000');
});

