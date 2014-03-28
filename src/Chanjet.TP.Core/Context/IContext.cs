using Chanjet.TP.Core.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core.Context
{
    public interface IContext
    {
        IUser CurrentUser { get; }
    }
}
