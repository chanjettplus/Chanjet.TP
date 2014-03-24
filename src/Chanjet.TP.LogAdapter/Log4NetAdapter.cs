using Chanjet.TP.Core;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Logger
{
    /// <summary>
    /// Log4Net适配器
    /// </summary>
    internal class Log4NetAdapter : ILogger
    {
        private ILog _logger;

        public Log4NetAdapter(ILog logger)
        {
            _logger = logger;
        }

        public void Debug(object message)
        {
            _logger.Debug(message);
        }

        public void Info(object message)
        {
            _logger.Info(message);
        }

        public void Warn(object message)
        {
            _logger.Warn(message);
        }

        public void Error(object message)
        {
            _logger.Error(message);
        }

        public void Fatal(object message)
        {
            _logger.Fatal(message);
        }

        public void Debug(string msgFormat, params object[] args)
        {
            _logger.Debug(TryFormart(msgFormat, args));
        }

        public void Info(string msgFormat, params object[] args)
        {
            _logger.Info(TryFormart(msgFormat, args));
        }

        public void Warn(string msgFormat, params object[] args)
        {
            _logger.Warn(TryFormart(msgFormat, args));
        }

        public void Error(string msgFormat, params object[] args)
        {
            _logger.Error(TryFormart(msgFormat, args));
        }

        public void Fatal(string msgFormat, params object[] args)
        {
            _logger.Fatal(TryFormart(msgFormat, args));
        }

        public bool IsDebugEnabled
        {
            get { return _logger.IsDebugEnabled; }
        }

        public bool IsInfoEnabled
        {
            get { return _logger.IsInfoEnabled; }
        }

        public bool IsWarnEnabled
        {
            get { return _logger.IsWarnEnabled; }
        }

        public bool IsErrorEnabled
        {
            get { return _logger.IsErrorEnabled; }
        }

        public bool IsFatalEnabled
        {
            get { return _logger.IsFatalEnabled; }
        }

        private string TryFormart(string s, params object[] args)
        {
            try
            {
                if (args == null || args.Length == 0)
                    return s;
                return string.Format(s, args);
            }
            catch
            {
                return String.Empty;
            }
        }

    }
}
