import {RedisClient} from "redis";
import getConnection from "./salesforce";

export const REDIS_KEY = "product_families";

//@ts-ignore
export default async (redisClient : RedisClient) => {
    // get connection to salesforce
    const conn = await getConnection();
    const data = await conn.describe("Product2");
    const field = data.fields.reduce((prev : any, field : any) => field.name === "Family" ? field : prev, undefined);
    const values = field.picklistValues.map((p:any) => ({"label": p.label, "value": p.value}));
    redisClient.set(REDIS_KEY, JSON.stringify(values));
}