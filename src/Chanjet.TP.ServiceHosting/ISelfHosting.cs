using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting
{
    public interface ISelfHosting : IDisposable
    {
        void Start();
        void Stop();


    }
}
