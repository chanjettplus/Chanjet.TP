using Castle.DynamicProxy;
using Chanjet.TP.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting
{
    public class DynamicProxyInterceptor : IInterceptor
    {
        public void Intercept(IInvocation invocation)
        {
            try
            {
                if (invocation.Method.Name == "GetService")
                {
                    if(invocation.Arguments[0] is String)
                    {
                        invocation.ReturnValue = DIContainerManager.Resolve(invocation.Arguments[0] as String);
                    }
                    else if(invocation.Arguments[0] is Type)
                    {
                        invocation.ReturnValue = DIContainerManager.Resolve(invocation.Arguments[0] as Type);
                    }
                    else
                    {
                        invocation.ReturnValue = DIContainerManager.Resolve(invocation.Method.ReturnType);
                    }
                    
                }
                else
                    invocation.Proceed();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
