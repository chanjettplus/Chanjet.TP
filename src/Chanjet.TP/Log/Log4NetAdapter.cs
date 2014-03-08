using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP
{
    /// <summary>
    /// Log4Net适配器
    /// </summary>
    internal class Log4NetAdapter : ILogger
    {
        public void Debug(object message)
        {
            throw new NotImplementedException();
        }

        public void Info(object message)
        {
            throw new NotImplementedException();
        }

        public void Warn(object message)
        {
            throw new NotImplementedException();
        }

        public void Error(object message)
        {
            throw new NotImplementedException();
        }

        public void Fatal(object message)
        {
            throw new NotImplementedException();
        }

        public void Debug(string msgFormat, params object[] args)
        {
            throw new NotImplementedException();
        }

        public void Info(string msgFormat, params object[] args)
        {
            throw new NotImplementedException();
        }

        public void Warn(string msgFormat, params object[] args)
        {
            throw new NotImplementedException();
        }

        public void Error(string msgFormat, params object[] args)
        {
            throw new NotImplementedException();
        }

        public void Fatal(string msgFormat, params object[] args)
        {
            throw new NotImplementedException();
        }

        public bool IsDebugEnabled
        {
            get { throw new NotImplementedException(); }
        }

        public bool IsInfoEnabled
        {
            get { throw new NotImplementedException(); }
        }

        public bool IsWarnEnabled
        {
            get { throw new NotImplementedException(); }
        }

        public bool IsErrorEnabled
        {
            get { throw new NotImplementedException(); }
        }

        public bool IsFatalEnabled
        {
            get { throw new NotImplementedException(); }
        }
    }
}
