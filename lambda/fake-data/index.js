'use strict'

const { faker } = require('@faker-js/faker');
const AWS = require("aws-sdk");
const os = require("os")

var s3 = new AWS.S3({})

exports.handler = (event, context, callback) => {

    const date = new Date()
    const key = date.toISOString().slice(0, 10)

    console.log("Key:", key)

    let v = 0;
    while (v <= process.env.NUMBER_OF_FILES) {
        let body = ""
        let i = 0;
        while (i <= process.env.BATCH_SIZE) {

            let payment_data = {
                id: faker.datatype.uuid(),
                name: faker.name.firstName(),
                last_name: faker.name.lastName(),
                amount: faker.finance.amount(),
                description: faker.lorem.paragraph(),
                vehicle: faker.vehicle.vehicle(),
                country: faker.address.country()
            }

            body = body + JSON.stringify(payment_data) + "\n"
            i++
        }

        const filename = faker.datatype.uuid()
        const params = {
            Body: body,
            Bucket: process.env.BUCKET_RAW,
            Key: `${key}/${filename}.json`,
        };

        console.log("Payload: ", params)


        const save = s3.putObject(params).promise()

        save
            .then(ok => context.succeed(ok))
            .catch(err => context.fail(err))
        v++
    }

    // console.log(items)

    // var body = ""

    // let i = 0;
    // while (i <= process.env.BATCH_SIZE) {

    //     let payment_data = {
    //         id:             faker.datatype.uuid(),
    //         name:           faker.name.firstName(),
    //         last_name:      faker.name.lastName(),
    //         amount:         faker.finance.amount(),
    //         description:    faker.lorem.paragraph(),
    //         vehicle:        faker.vehicle.vehicle(),
    //         country:        faker.address.country()
    //     }

    //     body = body + JSON.stringify(payment_data) + "\n"
    //     i++
    // }

    // const filename = faker.datatype.uuid()
    // const params = {
    //     Body: body,
    //     Bucket: process.env.BUCKET_RAW,
    //     Key: `${key}/${filename}.json`,
    // };

    // console.log("Payload: ", params)

    // const save = s3.putObject(params).promise()

    // save
    //     .then(ok => context.succeed(ok))
    //     .catch(err => context.fail(err))

    // console.log("done")

}