using Chanjet.TP.Core.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core.Context
{
    public class ThreadContext : IThreadContext
    {
        public ThreadContext(IUser user)
        {
            CurrentUser = user;
        }

        public IUser CurrentUser
        {
            get;
            private set;
        }
    }
}
