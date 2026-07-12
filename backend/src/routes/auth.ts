import { Router, type Request, type Response } from "express";
import { users } from "../db/schema.js";
import { eq } from "drizzle-orm";
import { db } from "../db/index.js";
import { scrypt, randomBytes } from "node:crypto";
import { promisify } from "node:util";
import { validate } from "../middleware/validate.js";
import { signupSchema, type SignupInput } from "../validation/schemas.js";

const scryptAsync = promisify(scrypt);

const authRouter = Router();

// Hash PIN helper using node:crypto
async function hashPin(pin: string): Promise<string> {
    const salt = randomBytes(16).toString("hex");
    const buf = (await scryptAsync(pin, salt, 64)) as Buffer;
    return `${buf.toString("hex")}.${salt}`;
}

authRouter.post("/signup", validate(signupSchema), async (req: Request, res: Response) => {
    const { username, pin, fullName, role } = req.body as SignupInput;

    // 1. Check if username is already taken
    const existingUser = await db.
        select().from(users).
        where(eq(users.username, username));

    if (existingUser.length > 0) {
        return res.status(400).json({ error: "User with the same username already exists" });
    }

    // 2. Hash PIN
    const hashedPin = await hashPin(pin);

    // 3. Insert new user into the database
    const [user] = await db.insert(users).values({
        username,
        pin: hashedPin,
        fullName,
        role,
    }).returning();

    if (!user) {
        return res.status(500).json({ error: "Failed to create user" });
    }

    const { pin: _, deletedAt: __, ...safeUser } = user;

    return res.status(201).json({
        message: "User registered successfully",
        user: safeUser,
    });
});

authRouter.get("/", (req, res) => {
    res.send("hey from auth");
});

export default authRouter;