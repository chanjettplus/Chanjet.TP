using Castle.DynamicProxy;
using Chanjet.TP.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting.Interceptors
{
    public class UnitOfWorkInterceptor : IInterceptor
    {
        private  IUnitOfWork _uow;
        public UnitOfWorkInterceptor(IUnitOfWork uow)
        {
            _uow = uow;
        }

        public void Intercept(IInvocation invocation)
        {
            _uow.Begin();
            invocation.Proceed();
            _uow.Commit();
        }
    }
}
