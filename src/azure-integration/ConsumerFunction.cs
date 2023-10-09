using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace azure_integration
{
    public class ConsumerFunction
    {
        [FunctionName("ServiceBusMessageConsumer")]
        public void Run([ServiceBusTrigger("%ServiceBus_QueueName%", Connection = "ServiceBus_ConnectionString")] string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}
