using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core
{
    /// <summary>
    /// ILogger 日志接口
    /// </summary>
    public interface ILogger
    {
        /// <summary>
        /// 输出调试信息
        /// </summary>
        /// <param name="message">信息对象</param>
        void Debug(object message);

        /// <summary>
        /// 输出提示信息
        /// </summary>
        /// <param name="message">信息对象</param>
        void Info(object message);

        /// <summary>
        /// 输出警告信息
        /// </summary>
        /// <param name="message">信息对象</param>
        void Warn(object message);

        /// <summary>
        /// 输出错误信息
        /// </summary>
        /// <param name="message">信息对象</param>
        void Error(object message);

        /// <summary>
        /// 输出严重错误信息
        /// </summary>
        /// <param name="message">信息对象</param>
        void Fatal(object message);

        /// <summary>
        /// 输出调试信息
        /// </summary>
        /// <param name="msgFormat">信息格式化串</param>
        /// <param name="args">参数</param>
        void Debug(string msgFormat, params object[] args);

        /// <summary>
        /// 输出提示信息
        /// </summary>
        /// <param name="msgFormat">信息格式化串</param>
        /// <param name="args">参数</param>
        void Info(string msgFormat, params object[] args);

        /// <summary>
        /// 输出警告信息
        /// </summary>
        /// <param name="msgFormat">信息格式化串</param>
        /// <param name="args">参数</param>
        void Warn(string msgFormat, params object[] args);

        /// <summary>
        /// 输出错误信息
        /// </summary>
        /// <param name="msgFormat">信息格式化串</param>
        /// <param name="args">参数</param>
        void Error(string msgFormat, params object[] args);


        /// <summary>
        /// 输出严重错误信息
        /// </summary>
        /// <param name="msgFormat">信息格式化串</param>
        /// <param name="args">参数</param>
        void Fatal(string msgFormat, params object[] args);


        /// <summary>
        /// 取得是否允许Debug级信息输出
        /// </summary>
        bool IsDebugEnabled { get; }

        /// <summary>
        /// 取得是否允许Info级信息输出
        /// </summary>
        bool IsInfoEnabled { get; }

        /// <summary>
        /// 取得是否允许Warn级信息输出
        /// </summary>
        bool IsWarnEnabled { get; }

        /// <summary>
        /// 取得是否允许Error级信息输出
        /// </summary>
        bool IsErrorEnabled { get; }

        /// <summary>
        /// 取得是否允许Fatal级信息输出
        /// </summary>
        bool IsFatalEnabled { get; }
    }
}
