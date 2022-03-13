'use strict'

const { faker } = require('@faker-js/faker');
const AWS = require("aws-sdk");
const os = require("os")

var s3 = new AWS.S3({})

exports.handler = async (event, context, callback) => {

    const date = new Date()
    const key = date.toISOString().slice(0, 10)

    console.log(key)

    const payment_data = {
        id: faker.datatype.uuid(),
        name: faker.name.firstName(),
        last_name: faker.name.lastName(),
        amount: faker.finance.amount(),
        description: faker.lorem.paragraph(),
        vehicle: faker.vehicle.vehicle(),
        country: faker.address.country()
    }

    const params = {
        Body: String(JSON.stringify(payment_data)),
        Bucket: process.env.BUCKET_RAW,
        Key: `${key}/${payment_data.id}.json`,
    };

    s3.putObject(params, (err, data) => {
        if (err) {
            console.log(err)
        }
        console.log("Sucess to Upload Data", data)
    })

    console.log(payment_data)



}