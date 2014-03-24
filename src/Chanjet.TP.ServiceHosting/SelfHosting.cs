using Nancy.Hosting.Self;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting
{
    public class SelfHosting : ISelfHosting
    {
        public NancyHost _host;
        public SelfHosting(params Uri[] baseUris)
        {
            _host = new NancyHost(baseUris);
        }

        public void Start()
        {
            _host.Start();
        }

        public void Stop()
        {
            _host.Stop();
        }

        public void Dispose()
        {
            _host.Dispose();
        }
    }
}
