import { Router, type Request, type Response } from "express";
import { users } from "../db/schema.js";
import { eq } from "drizzle-orm";
import { db } from "../db/index.js";
import { scrypt, randomBytes } from "node:crypto";
import { promisify } from "node:util";

const scryptAsync = promisify(scrypt);

const authRouter = Router();

interface signupBody {
    username: string;
    pin: string;
    fullName: string;
    role?: "admin" | "pharmacist" | "cashier";
}

// Hash PIN helper using node:crypto
async function hashPin(pin: string): Promise<string> {
    const salt = randomBytes(16).toString("hex");
    const buf = (await scryptAsync(pin, salt, 64)) as Buffer;
    return `${buf.toString("hex")}.${salt}`;
}

authRouter.post("/signup", async (req: Request<{}, {}, signupBody>, res: Response) => {
    try {
        const { username, pin, fullName, role } = req.body;

        // 1. Basic validation
        if (!username || !pin || !fullName) {
            return res.status(400).json({ error: "username, pin, and fullName are required" });
        }

        // 2. Validate PIN format (should be exactly 4 digits)
        if (!/^\d{4}$/.test(pin)) {
            return res.status(400).json({ error: "PIN must be exactly 4 digits" });
        }

        // 3. Validate Role if provided
        if (role && !["admin", "pharmacist", "cashier"].includes(role)) {
            return res.status(400).json({ error: "Invalid role. Must be 'admin', 'pharmacist', or 'cashier'" });
        }

        // 4. Check if username is already taken
        const existingUser = await db.
            select().from(users).
            where(eq(users.username, username));

        if (existingUser.length > 0) {
            return res.status(400).json({ error: "User with the same username already exists" });
        }

        // 5. Hash PIN
        const hashedPin = await hashPin(pin);

        // 6. Insert new user into the database
        const [newUser] = await db.insert(users).values({
            username,
            pin: hashedPin,
            fullName,
            role: role || "pharmacist",
        }).returning();

        if (!newUser) {
            return res.status(500).json({ error: "Failed to create user" });
        }

        return res.status(201).json({
            message: "User registered successfully",
            user: {
                id: newUser.id,
                username: newUser.username,
                fullName: newUser.fullName,
                role: newUser.role,
            }
        });
    } catch (e: any) {
        res.status(500).json({ error: e.message || e });
    }
});

authRouter.get("/", (req, res) => {
    res.send("hey from auth")
});

export default authRouter;