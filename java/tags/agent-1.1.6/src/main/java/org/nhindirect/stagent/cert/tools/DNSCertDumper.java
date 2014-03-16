package org.nhindirect.stagent.cert.tools;

import java.io.File;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.Collection;

import javax.mail.internet.InternetAddress;

import org.apache.commons.io.FileUtils;
import org.nhindirect.stagent.cert.impl.DNSCertificateStore;


public class DNSCertDumper 
{
	public static void main(String[] args)
	{
		
		if (args.length == 0)
		{
            printUsage();
            System.exit(-1);			
		}		
		//String emailAddress = "Richard_Campbell@direct.healthvault-stage.com";
		//String emailAddress = "ca.direct.healthvault-stage.com";
		//String emailAddress = "ca.direct.healthvault-stage.com";
		String emailAddress = ""; //"beau@direct3.h1sp.com";
		String[] servers = null;	
		String outFile = null;
		
		// Check parameters
        for (int i = 0; i < args.length; i++)
        {
            String arg = args[i];

            // Options
            if (!arg.startsWith("-"))
            {
                System.err.println("Error: Unexpected argument [" + arg + "]\n");
                printUsage();
                System.exit(-1);
            }
            else if (arg.equalsIgnoreCase("-add"))
            {
                if (i == args.length - 1 || args[i + 1].startsWith("-"))
                {
                    System.err.println("Error: Missing email address");
                    System.exit(-1);
                }
                
                emailAddress = args[++i];
                
            }
            else if (arg.equals("-server"))
            {
                if (i == args.length - 1 || args[i + 1].startsWith("-"))
                {
                    System.err.println("Error: Missing DNS server list");
                    System.exit(-1);
                }
                servers = args[++i].split(",");
            }
            else if (arg.equals("-out"))
            {
                if (i == args.length - 1 || args[i + 1].startsWith("-"))
                {
                    System.err.println("Error: Missing output file.");
                    System.exit(-1);
                }
                outFile = args[++i];
            }
            else if (arg.equals("-help"))
            {
                printUsage();
                System.exit(-1);
            }            
            else
            {
                System.err.println("Error: Unknown argument " + arg + "\n");
                printUsage();
                System.exit(-1);
            }
        }		
			
        if (emailAddress == null || emailAddress.isEmpty())
        {
        	System.err.println("You must provide an email address.");
        	printUsage();
        }        	
        else
		{
        	DNSCertificateStore dnsStore = (servers != null) ? new DNSCertificateStore(Arrays.asList(servers)) : new DNSCertificateStore();
				
			try
			{
				Collection<X509Certificate> certs = dnsStore.getCertificates(new InternetAddress(emailAddress));
				if (certs == null || certs.size() == 0)
				{
					System.out.println("No certs found");
				}
				else
				{
					int idx = 1;
					for (X509Certificate cert : certs)
					{
						String certFileName= "";
						String certFileHold = (outFile == null || outFile.isEmpty())  ? emailAddress + ".der" : outFile;
						if (certs.size() > 1)
						{
							int index = certFileHold.lastIndexOf(".");
							if (index < 0)
								certFileHold += "(" + idx + ")";
							else
							{
								certFileName = certFileHold.substring(0, index - 1) + "(" + idx + ")" + certFileHold.substring(index);
							}
									
						}
						else
							certFileName = certFileHold;
						
						File certFile = new File(certFileName);
						if (certFile.exists())
							certFile.delete();
						
						
						System.out.println("Writing cert file: " + certFile.getAbsolutePath());
						FileUtils.writeByteArrayToFile(certFile, cert.getEncoded());						
						
						++idx;
					}
				}
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}		
		System.exit(0);
	}
	
    private static void printUsage()
    {
        StringBuffer use = new StringBuffer();
        use.append("Usage:\n");
        use.append("java DNSCertDumper (options)...\n\n");
        use.append("options:\n");
        use.append("-add address		Email address of org/domain to retrieve certs for.\n");
        use.append("\n");
        use.append("-server     		Comma delimited list of DNS servers used for lookup.\n");
        use.append("			Default: Local machine's configured DNS server(s)\n\n");            
        use.append("-out  Out File		Optional output file name for the cert.\n");
        use.append("			Default: <email address>(<cert num>).der\n\n");    
        

        System.err.println(use);        
    }	
}
