/* 
 Copyright (c) 2010, Direct Project
 All rights reserved.

 Authors:
    John Theisen
  
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of The Direct Project (directproject.org) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
*/
using System;
using System.Collections.Generic;

namespace Health.Direct.Common.Container
{
    ///<summary>
    /// SimpleDependencyResolver provides a simple (non-external) container
    /// so that dependencies can be isolated and other implementors of an
    /// agent or gateway can slide in their own container library.
    ///</summary>
    public class SimpleDependencyResolver : IDependencyResolver
    {
        private readonly Dictionary<Type, Func<object>> m_types;

        ///<summary>
        /// A simple <see cref="Dictionary{TKey,TValue}"/> based dependency
        /// resolver. All dependencies need to be initialized on startup and
        /// prior to calling to <see cref="IoC.Initialize{T}"/>.
        ///</summary>
        public SimpleDependencyResolver()
        {
            m_types = new Dictionary<Type, Func<object>>();
        }

        ///<summary>
        /// Given a specific type, return an instance of that type.
        ///</summary>
        ///<typeparam name="T">The type to attempt resolution</typeparam>
        ///<returns>An instance of type <typeparamref name="T"/></returns>
        public T Resolve<T>()
        {
            return (T) m_types[typeof (T)]();
        }

        /// <summary>
        /// Registers a specific instance <paramref name="obj"/> type <typeparamref name="T"/>
        /// with the container.
        /// </summary>
        /// <typeparam name="T">The type to register</typeparam>
        /// <param name="obj">The specific instance to register</param>
        /// <returns>An instance of self so the Register calls can be chained.</returns>
        public SimpleDependencyResolver Register<T>(T obj)
        {
            return Register<T>(() => obj);
        }

        ///<summary>
        /// Registers a function, <paramref name="functor"/>, that returns an instance of type <typeparamref name="T"/>
        ///</summary>
        ///<param name="functor">The function that produces a new instance of <typeparamref name="T"/></param>
        ///<typeparam name="T">The type to register</typeparam>
        ///<returns>An instance of self so the Register calls can be chained.</returns>
        public SimpleDependencyResolver Register<T>(Func<object> functor)
        {
            return Register(typeof (T), functor);
        }

        private SimpleDependencyResolver Register(Type serviceType, Func<object> functor)
        {
            m_types.Add(serviceType, functor);
            return this;
        }

        ///<summary>
        /// Register all of the components found in the <see cref="SimpleContainerSection"/>
        ///</summary>
        ///<param name="section">The configuration section</param>
        ///<returns>An instance of self so the Register calls can be chained.</returns>
        public SimpleDependencyResolver RegisterConfig(SimpleContainerSection section)
        {
            for (int i = 0; i<section.Components.Count; i++)
            {
                SimpleComponentElement component = section.Components[i];
                Register(component.ServiceType, GetCreator(component));
            }

            return this;
        }

        private static Func<object> GetCreator(SimpleComponentElement component)
        {
            if (component.Scope == InstanceScope.Transient)
            {
                return component.CreateInstance;
            }
            
            object instance = component.CreateInstance();
            return () => instance;
        }
    }
}