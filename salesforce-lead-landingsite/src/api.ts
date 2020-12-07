import express from "express";
import getRedisClient from "./redis";
import {REDIS_KEY} from "./product-cache";
import getConnection from "./salesforce";

export default () => {
    const router = express.Router();
    //@ts-ignore
    router.get("/productfamilies", async (req, res) => {
        await getRedisClient().get(REDIS_KEY, (err, data) => {
            if (err) return res.status(500).type("json").send({"status": "ERROR", "message": err.message});
            res.type("json");
            res.send(JSON.parse(data!));
        });
    })

    router.post("/createlead", async (req, res) => {
        const body = req.body;
        const conn = await getConnection();

        await conn.create("Lead", {
            "FirstName": body.fn,
            "LastName": body.ln,
            "Company": body.company,
            "Email": body.email,
            "Product_Family__c": body.product,
            "OwnerId": process.env.LEAD_OWNER_ID
        });
        res.type("json").send({
            "status": "OK"
        })
    })

    return router;
}