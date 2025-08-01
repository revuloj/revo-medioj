#!/usr/bin/perl -w

use JSON;
use MIME::Entity;
#use Digest::SHA qw(hmac_sha256_hex);

use lib("/usr/local/bin");
use lib("./bin");
use mailsender;

my $from    = $ENV{"TEST_RETADRESO"};
my $name    = "Afido-Testo";
my $to      = $ENV{"TEST_RETADRESO"};
my $subject = "testa retpoŝto de Afido";
my $message = "Tio ĉi estas testo de procesumo voko-afido.";

unless ($from) {
    die "Vi devas antaŭdifini medio-variablon TEST_RETADRESO por doni unu retadreson kien sendiĝas la test-mesaĝo.";
}

$IO::Socket::SSL::DEBUG=3;

my $mailer = mailsender::smtp_connect;

print "\nDOM:".$mailer->domain();
print "\nBAN:".$mailer->banner();
print "\nSSL:".$mailer->can_ssl();
print "\n\n";

$mail_handle = build MIME::Entity(Type=>"multipart/mixed",
    From=>"$from",
    To=>"$to",
    Subject=>"$subject");   

$mail_handle->attach(Type=>"text/plain",
    Encoding=>"quoted-printable",
    Data=>$message);

unless (mailsender::smtp_send($mailer,$from,$to,$mail_handle)) {
    warn "Ne povas forsendi retpoŝtan raporton!\n";
    next;
}

#mailsender::smtp_send($mailer,$top);

mailsender::smtp_quit($mailer);
