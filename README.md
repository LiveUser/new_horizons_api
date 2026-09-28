# New Horizons API

A NASA modern Horizons API abstraction layer. Hecho en Puerto Rico por Radamés Jomuel Valentín Reyes.

## API Overview
This API makes use of graphene_server which means that all requests and responses are in BSON format. Every request is of type POST. Every request must be sent to the path /graphene since it is a single endpoint API.

## Requests
### List Major Bodies
~~~bson
{
  "variables": {},
  "query": "listMajorBodies"
}
~~~
### Get Major Body Ephemeris Data
~~~bson
{
  "variables": {
    "bodyID": 299,
    "startTime": "2026-09-28T14:18:03-04:00",
    "stopTime": "2026-09-29T14:18:03-04:00",
    "simulationSteps": 10,
    "simulationStepsUnit": "",
  },
  "query": "functionName"
}
~~~