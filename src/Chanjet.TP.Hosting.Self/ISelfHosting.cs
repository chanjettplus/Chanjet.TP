using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Hosting.Self
{
    public interface ISelfHosting : IDisposable
    {
        void Start();
        void Stop();


    }
}
