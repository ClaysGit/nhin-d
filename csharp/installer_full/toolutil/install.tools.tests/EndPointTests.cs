﻿/* 
 Copyright (c) 2010, Direct Project
 All rights reserved.

 Authors:
    Joseph Shook     
   
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of The Direct Project (directproject.org) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
*/

using System;
using System.IO;
using Health.Direct.Install.Tools;
using Xunit;

namespace install.tools.tests
{
    public class EndPointTests
    {
        [Fact]
        public void Test()
        {
            EndPoint endPoint = new EndPoint();
            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/CertificateService.svc/Certificates"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/CertificateService.svc/Anchors"));

            Assert.False(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/CertificateService.svc/Addresses"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/DomainManagerService.svc/Addresses"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/DomainManagerService.svc/Domains"));
            
            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/DomainManagerService.svc/DnsRecords"));
            
            Assert.False(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/DomainManagerService.svc/Authentication"));
            
            Assert.True(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/AuthManagerService.svc/Authentication"));

            Assert.False(endPoint.TestWcfSoapConnection(
                "http://DirectGateway.South.Hobo.Lab/ConfigService/AuthManagerService.svc/Certificates"));

            Assert.False(endPoint.TestWcfSoapConnection(
               "http://badhostname/ConfigService/AuthManagerService.svc/Certificates"));
            
        }


        [Fact]
        public void TestLocalhost()
        {
            EndPoint endPoint = new EndPoint();
            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/CertificateService.svc/Certificates"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/CertificateService.svc/Anchors"));

            Assert.False(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/CertificateService.svc/Addresses"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/DomainManagerService.svc/Addresses"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/DomainManagerService.svc/Domains"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/DomainManagerService.svc/DnsRecords"));

            Assert.False(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/DomainManagerService.svc/Authentication"));

            Assert.True(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/AuthManagerService.svc/Authentication"));

            Assert.False(endPoint.TestWcfSoapConnection(
                "http://localhost/ConfigService/AuthManagerService.svc/Certificates"));

            Assert.False(endPoint.TestWcfSoapConnection(
               "http://badhostname/ConfigService/AuthManagerService.svc/Certificates"));

        }

    }
}
