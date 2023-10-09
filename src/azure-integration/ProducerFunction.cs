using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace azure_integration
{
    public static class ProducerFunction
    {
        [FunctionName("ServiceBusMessageProducer")]
        [return: ServiceBus(queueOrTopicName: "%ServiceBus_QueueName%", Connection = "ServiceBus_ConnectionString")]
        public static string ServiceBusOutput(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] dynamic input,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            log.LogInformation($"C# function processed: {input.text}");

            return input.text;
        }
    }
}
