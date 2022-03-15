import sys
from pyspark.context import SparkContext
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.transforms import *
from awsglue.job import Job
from datetime import date

args = getResolvedOptions(sys.argv, [
	'JOB_NAME',
	'source-bucket',
	'lake-bucket',
	'number-of-partitions'
])

print("AQUI OS ARGS")
print(args)

glueContext = GlueContext(SparkContext.getOrCreate())
spark = glueContext.spark_session

key = date.today()

job = Job(glueContext)
job.init(args['JOB_NAME'], args)

inputPath = args['source-bucket'] + '/' + key
outputPath = args['lake-bucket']  + '/' + key

numberOfPartitions = int(args.get('number-of-partitions', 1))

input_dyf = glueContext.create_dynamic_frame_from_options("s3", {
		"paths": [ inputPath ],
		"recurse": True,
		"groupFiles": "inPartition"
	},
	format = "json"
)

repartitionedDYF = input_dyf.repartition(numberOfPartitions)
glueContext.write_dynamic_frame.from_options(
	frame = repartitionedDYF,
	connection_type = "s3",
	connection_options = {"path": outputPath},
	format = "glueparquet"
)

job.commit()