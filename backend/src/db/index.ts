import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

const pool = new Pool({
    connectionString: "postgresql://postgres:Kekoahmed12@db:5432/drugdb"
});
export const db = drizzle(pool);